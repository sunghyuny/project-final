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
    trip_plan_id = request.session.get('trip_plan_id')

    if not trip_plan_id:
        return HttpResponse("Error: Session does not contain trip plan information")

    try:
        trip_plan = TripPlan.objects.get(id=trip_plan_id)
    except ObjectDoesNotExist:
        return HttpResponse("Error: Trip plan does not exist")

    if request.method == 'POST':
        latitude = request.POST.get('latitude')
        longitude = request.POST.get('longitude')

        if not latitude or not longitude:
            return HttpResponse("Error: Missing coordinates")

        naver_api_url = f"https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords={longitude},{latitude}&orders=addr&output=json"
        headers = {
            "X-NCP-APIGW-API-KEY-ID": "8rmgkdfw2q",
            "X-NCP-APIGW-API-KEY": "7C5A0ZwU9zwbjb9vn5vRnB3fgBmv1rvOhuXi8F5L"
        }
        response = requests.get(naver_api_url, headers=headers)

        if response.status_code == 200:
            data = response.json()
            results = data.get('results')
            if results and len(results) > 0:
                region_name = results[0]['region']['area1']['name']
                trip_plan.destination = region_name
                trip_plan.save()
                return render(request, 'Planner/lodging.html', {'region_name': region_name})
            else:
                return HttpResponse("Error: Location data is incomplete or incorrect")
        else:
            return HttpResponse(f"Error: Unable to fetch location data, status code {response.status_code}")
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