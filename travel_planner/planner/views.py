# views.py
from django.contrib.auth.decorators import login_required
from django.contrib.sites import requests
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse,HttpRequest
from django.shortcuts import render, redirect
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
    if request.method == 'POST':
        # 사용자가 제출한 폼 데이터 가져오기
        arrival_date = request.POST.get('arrival_date')
        adults = int(request.POST.get('adults'))
        teens = int(request.POST.get('teens'))
        children = int(request.POST.get('children'))
        total_people = adults + teens + children

        # 현재 로그인한 사용자를 가져와서 TripPlan을 생성할 때 user 필드에 할당
        trip_plan = TripPlan.objects.create(
            arrival_date=arrival_date,
            total_people=total_people,
            user=request.user  # 현재 로그인한 사용자를 할당
        )
        request.session['trip_plan_id'] = trip_plan.id  # 세션에 TripPlan ID 저장
        return redirect('/planner/plan1/')
    return render(request, 'Planner/schedule.html')


def location(request):
    # 세션에서 여행 계획 ID 가져오기
    trip_plan_id = request.session.get('trip_plan_id')

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
        selected_activity_id = request.POST.get('selected_activity_id')  # 수정된 부분
        selected_activity = Activity.objects.get(pk=selected_activity_id)
        trip_plan.selected_activity = selected_activity
        trip_plan.save()

        return redirect('/planner/plan4/')

    activities = Activity.objects.all()
    return render(request, 'Planner/activity.html', {'activities': activities})

def plan4(request):
    trip_plan_id = request.session.get('trip_plan_id')
    trip_plan = TripPlan.objects.get(id=trip_plan_id)
    selected_accommodation = trip_plan.selected_accommodation
    selected_activity = trip_plan.selected_activity

    return render(request, 'Planner/summary.html', {
        'trip_plan': trip_plan,
        'selected_accommodation': selected_accommodation,
        'selected_activity': selected_activity
    })