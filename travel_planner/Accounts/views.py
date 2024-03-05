from .models import CustomUser
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth import logout  # 추가
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
