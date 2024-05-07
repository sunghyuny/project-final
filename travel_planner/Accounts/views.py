from django.contrib.auth.decorators import login_required

from .models import CustomUser
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth import logout  # 추가
from planner.models import *
from django.contrib.auth.forms import AuthenticationForm
def signup(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        email = request.POST.get('email')
        age = request.POST.get('age')
        mbti = request.POST.get('mbti')
        gender = request.POST.get('gender')

        # 유효성 검사는 간단한 예시로 하였습니다.
        if username and password and email and age and mbti and gender:
            # 사용자 생성
            user = CustomUser.objects.create_user(username=username, password=password, email=email, age=age, mbti=mbti, gender=gender)
            messages.success(request, '회원가입이 성공적으로 완료되었습니다.')
            return redirect('/')  # 메인 페이지로 리디렉션
        else:
            messages.error(request, '입력이 올바르지 않습니다. 모든 필드를 채워주세요.')
    return render(request, 'Accounts/signup.html')

def user_login(request):
    if request.method == 'POST':
        email = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=email, password=password)
        if user is not None:
            login(request, user)
            return redirect('/')
        else:
            messages.error(request, 'Invalid username or password.')
    return render(request, 'Accounts/login.html')

def logout_view(request):
    logout(request)  # 로그아웃
    return redirect('/')  # 로그아웃 후 리다이렉트할 URL

@login_required
def my_page(request):
    user = request.user
    # 사용자 정보를 가져와서 처리하는 코드 작성
    context = {
        'user': user,
        # 필요한 다른 데이터도 추가할 수 있음
    }
    return render(request, 'Mypage/myinfo.html', context)

def user_plan(request):
    # 현재 로그인한 사용자의 여행 계획을 가져옵니다.
    user_trip_plans = TripPlan.objects.filter(user=request.user)

    # 여행 계획과 관련된 정보를 리스트에 저장합니다.
    trip_plan_info = []
    for trip_plan in user_trip_plans:
        trip_info = {
            'period': f"기간 : {trip_plan.arrival_date.strftime('%Y.%m.%d')}~{trip_plan.departure_date.strftime('%Y.%m.%d')}",  # 여행 기간
            'member': f"인원수 : {trip_plan.total_people}명",  # 여행 인원수
            'destination': trip_plan.destination,  # 여행 목적지
            'transportation_method': trip_plan.transportation_method,  # 교통 수단
            'selected_accommodation': trip_plan.selected_accommodation,  # 선택된 숙소
            'selected_activity': trip_plan.selected_activity,  # 선택된 활동
        }
        trip_plan_info.append(trip_info)

    return render(request, 'Mypage/Myplan.html', {'trip_plan_info': trip_plan_info})
    