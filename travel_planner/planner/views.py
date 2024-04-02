# views.py

from django.shortcuts import render, redirect
from django.http import HttpResponseRedirect
from .models import *




def planner(request):
    return render(request, 'Planner/schedule.html')
def create_activity(request):
    if request.method == 'POST':
        new_activity = activity()
        new_activity.name = request.POST.get('name')
        new_activity.price = request.POST.get('price')
        new_activity.photo = request.FILES.get('photo')
        new_activity.location = request.POST.get('location')
        new_activity.telephone = request.POST.get('telephone')
        new_activity.time = request.POST.get('time')

        # 카테고리 처리
        category_name = request.POST.get('category')
        category, created = activity_category.objects.get_or_create(name=category_name)
        new_activity.category = category

        new_activity.save()
        return redirect('/')  # 성공 시 리디렉트될 URL을 설정하세요.

    return render(request, 'pages/activity_create.html')


def trip_plan_form(request):
    if request.method == 'POST':
        arrival_date = request.POST.get('arrival_date')
        adults = int(request.POST.get('adults'))
        teens = int(request.POST.get('teens'))
        children = int(request.POST.get('children'))

        total_people = adults + teens + children

        trip_plan = TripPlan.objects.create(arrival_date=arrival_date, total_people=total_people)
        trip_plan.save()

        return redirect('다음_페이지_뷰_이름')

    return render(request, 'Planner/schedule.html')

def plan1(request):
    return render(request, 'Planner/location.html')

def plan2(reqeust):
    return render(reqeust, 'Planner/lodging.html')

def plan3(request):
    return render(request, 'Planner/activity.html')

def plan4(request):
    return render(request, 'Planner/summary.html')