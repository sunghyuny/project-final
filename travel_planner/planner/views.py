# views.py
from django.contrib.auth.decorators import login_required
from django.contrib.sites import requests
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse,HttpRequest
from django.shortcuts import render, redirect, get_object_or_404

from Accounts.models import Friend
from .models import *
from hotel.models import *
from thesights.models import *


def create_activity(request):
    if request.method == 'POST':
        new_activity = Activity()
        new_activity.name = request.POST.get('name')
        new_activity.price = request.POST.get('price')
        new_activity.photo = request.FILES.get('photo')
        new_activity.location = request.POST.get('location')
        new_activity.telephone = request.POST.get('telephone')
        new_activity.time = request.POST.get('time')

        # 카테고리 처리
        category_name = request.POST.get('category')
        category, created = ActivityCategory.objects.get_or_create(name=category_name)
        new_activity.category = category

        new_activity.save()
        return redirect('/')  # 성공 시 리디렉트될 URL을 설정하세요.

    return render(request, 'pages/activity_create.html')


@login_required
def trip_plan_form(request):
    user = request.user
    try:
        friends = Friend.objects.get(current_user=user).users.all()
    except Friend.DoesNotExist:
        friends = CustomUser.objects.none()
    
    if request.method == 'POST':
        arrival_date = request.POST.get('arrival_date')
        departure_date = request.POST.get('departure_date')  # 출발 날짜도 폼에서 가져오기
        adults = int(request.POST.get('adults', 0))  # 기본값 0
        teens = int(request.POST.get('teens', 0))    # 기본값 0
        children = int(request.POST.get('children', 0))  # 기본값 0
        total_people = adults + teens + children
        friend_ids = request.POST.getlist('friends')
    
        trip_plan = TripPlan.objects.create(
            arrival_date=arrival_date,
            departure_date=departure_date,  # 출발 날짜 저장
            total_people=total_people,
            user=user
        )
    
        trip_plan.friends.set(friend_ids)
        trip_plan.save()
        
        # 세션에 인원 데이터를 저장
        request.session['adults'] = adults
        request.session['teens'] = teens
        request.session['children'] = children
    
        request.session['trip_plan_id'] = trip_plan.id
        return redirect('/planner/plan1/')
    
    return render(request, 'Planner/schedule.html', {'friends': friends})

def location(request):
    # 세션에서 여행 계획 ID 가져오기
    trip_plan_id = request.session.get('trip_plan_id')
    destination = request.session.get('destination')

    if not trip_plan_id:
        return HttpResponse("Error: Session does not contain trip plan information")

    try:
        # 세션에 저장된 여행 계획 ID를 사용하여 해당 여행 계획 가져오기
        trip_plan = TripPlan.objects.get(id=trip_plan_id)
    except TripPlan.DoesNotExist:
        return HttpResponse("Error: Trip plan does not exist")

    if request.method == 'POST':
        destination = request.POST.get('destination')
        if not destination:
            return HttpResponse("Error: Missing destination")

        # 여행 계획의 목적지 필드에 입력된 목적지 저장
        trip_plan.destination = destination
        trip_plan.save()

        return redirect('/planner/plan2/')  # 다음 페이지 URL로 변경하세요.

    return render(request, 'Planner/location.html')


def plan2(request):
    trip_plan_id = request.session.get('trip_plan_id')
    trip_plan = TripPlan.objects.get(id=trip_plan_id)

    if request.method == 'POST':
        selected_accommodation_id = request.POST.get('accommodation_id')
        selected_accommodation = Accommodation.objects.get(pk=selected_accommodation_id)
        trip_plan.selected_accommodation = selected_accommodation
        trip_plan.save()

        # 선택이 완료되면 다음 페이지로 이동합니다.
        return redirect('/planner/plan3/')

    accommodations = Accommodation.objects.all()
    return render(request, 'Planner/lodging.html', {'accommodations': accommodations})

def plan3(request):
    trip_plan_id = request.session.get('trip_plan_id')
    trip_plan = TripPlan.objects.get(id=trip_plan_id)

    if request.method == 'POST':
        selected_activity_id = request.POST.getlist('selected_activity_id')  # 여러 활동을 선택할 수 있도록 수정
        selected_activity = Activity.objects.filter(pk__in=selected_activity_id)
        
        # 기존 활동 지우고 선택된 활동 추가
        trip_plan.selected_activity.set(selected_activity)  # ManyToManyField에 다중 저장
        trip_plan.save()

        return redirect('/planner/plan4/')

    activities = Activity.objects.all()
    return render(request, 'Planner/activity.html', {'activities': activities})

    
@login_required
def plan4(request):
    trip_plan_id = request.session.get('trip_plan_id')
    
    if not trip_plan_id:
        return redirect('planner:trip_plan_form')

    try:
        trip_plan = TripPlan.objects.get(id=trip_plan_id)
    except TripPlan.DoesNotExist:
        return redirect('planner:trip_plan_form')

    # 세션에서 저장된 인원 데이터 불러오기
    destination = request.session.get('destination') or trip_plan.destination
    adults = request.session.get('adults', 0)
    teens = request.session.get('teens', 0)
    children = request.session.get('children', 0)
    
    if request.method == 'POST':
        # 플랜을 최종 저장 후 세션을 초기화
        request.session.pop('trip_plan_id', None)
        request.session.pop('destination', None)
        request.session.pop('adults', None)
        request.session.pop('teens', None)
        request.session.pop('children', None)
        
        return redirect('planner:trip_plan_form')  # 초기화 후 첫 페이지로 리다이렉트

    # 선택된 모든 활동의 총 가격 계산
    total_activity_cost = sum(int(activity.price) for activity in trip_plan.selected_activity.all())

    return render(request, 'Planner/summary.html', {
        'trip_plan': trip_plan,
        'destination': destination,
        'selected_accommodation': trip_plan.selected_accommodation,
        'selected_activities': trip_plan.selected_activity.all(),  # 모든 선택된 활동 가져오기
        'children': children,
        'teens': teens,
        'adults': adults,
        'total_people': trip_plan.total_people,
        'total_activity_cost': total_activity_cost  # 선택된 모든 활동의 총 가격
    })
