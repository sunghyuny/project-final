import json

from django.contrib.auth.decorators import login_required
from django.http import HttpResponse, HttpResponseForbidden, JsonResponse

from match.models import ChatRoom
from post.models import Post
from travel.models import Reservation as TravelReservation
from hotel.models import HotelReservation as HotelReservation
from .models import *
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout  # 추가
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
            user = CustomUser.objects.create_user(
                username=username, password=password, email=email, age=age, mbti=mbti, gender=gender
            )
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
    context = {
        'user': user,
    }
    return render(request, 'Mypage/Myinfo.html', context)

@login_required
def edit_profile(request):
    user = request.user
    if request.method == 'POST':
        user.age = request.POST.get('age')
        user.mbti = request.POST.get('mbti')
        user.gender = request.POST.get('gender')
        if 'profile_picture' in request.FILES:
            user.profile_picture = request.FILES['profile_picture']
        user.save()
        messages.success(request, '프로필이 성공적으로 업데이트되었습니다.')
        return redirect('/Accounts/mypage/')
    
    context = {
        'user': user,
    }
    return render(request, 'Mypage/EditProfile.html', context)

@login_required
def user_plan(request):
    user = request.user
    user_trip_plans = TripPlan.objects.filter(user=user) | TripPlan.objects.filter(friends=user)

    trip_plan_info = []
    for trip_plan in user_trip_plans.distinct():
        trip_info = {
            'id': trip_plan.id,
            'period': f"기간 : {trip_plan.arrival_date.strftime('%Y.%m.%d')}~{trip_plan.departure_date.strftime('%Y.%m.%d')}",
            'member': f"인원수 : {trip_plan.total_people}명",
            'destination': trip_plan.destination,
            'transportation_method': trip_plan.transportation_method,
            'selected_accommodation': trip_plan.selected_accommodation,
            'selected_activity': trip_plan.selected_activity,
            'friends': list(trip_plan.friends.all())  # 계획에 추가된 친구들을 명시적으로 리스트로 변환
        }
        trip_plan_info.append(trip_info)

    return render(request, 'Mypage/Myplan.html', {'trip_plan_info': trip_plan_info})


@login_required
def userplan_detail(request, user_plan_id):
    user_plan = get_object_or_404(TripPlan, id=user_plan_id)
    friends_list = list(user_plan.friends.all())
    invites = FriendRequest.objects.filter(to_user=request.user, trip_plan=user_plan, status='pending')
    return render(request, 'Detail/plan.html', {'user_plan': user_plan, 'friends': friends_list, 'invites': invites})

@login_required
def plan_delete(request, plan_id):
    plan = get_object_or_404(TripPlan, pk=plan_id)
    if request.method == 'POST':
        plan.delete()
        return redirect('/Accounts/userplan/')
    else:
        return HttpResponse("GET 요청은 허용되지 않습니다.")


@login_required
def plan_edit(request, plan_id):
    user = request.user
    plan = get_object_or_404(TripPlan, pk=plan_id)

    if plan.user != user:
        return HttpResponseForbidden("이 계획을 수정할 권한이 없습니다.")

    try:
        friends = Friend.objects.get(current_user=user).users.all()
    except Friend.DoesNotExist:
        friends = CustomUser.objects.none()

    if request.method == 'POST':
        arrival_date = request.POST.get('arrival_date')
        departure_date = request.POST.get('departure_date')
        total_people = request.POST.get('total_people')
        friend_ids = request.POST.getlist('friends')

        plan.arrival_date = arrival_date
        plan.departure_date = departure_date
        plan.total_people = total_people
        plan.friends.set(friend_ids)
        plan.save()

        for friend_id in friend_ids:
            friend = CustomUser.objects.get(id=friend_id)
            if not FriendRequest.objects.filter(from_user=user, to_user=friend, trip_plan=plan).exists():
                FriendRequest.objects.create(from_user=user, to_user=friend, trip_plan=plan)

        messages.success(request, "계획이 성공적으로 수정되었습니다.")
        return redirect('/Accounts/userplan/')

    return render(request, 'Detail/plan_edit.html', {'user_plan': plan, 'friends': friends})

@login_required
def accept_friend_request(request, request_id):
    friend_request = get_object_or_404(FriendRequest, id=request_id)
    if friend_request.to_user == request.user:
        friend_request.accept()
        messages.success(request, "친구 요청을 수락했습니다.")
    else:
        messages.error(request, "이 친구 요청을 수락할 권한이 없습니다.")
    return redirect('/Accounts/Myfriends/')

@login_required
def reject_friend_request(request, request_id):
    friend_request = get_object_or_404(FriendRequest, id=request_id)
    if friend_request.to_user == request.user:
        friend_request.reject()
        messages.success(request, "친구 요청을 거절했습니다.")
    else:
        messages.error(request, "이 친구 요청을 거절할 권한이 없습니다.")
    return redirect('/Accounts/Myfriends/')

@login_required
def send_friend_request(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        if email:
            try:
                to_user = CustomUser.objects.get(email=email)
                if to_user == request.user:
                    messages.error(request, "자신에게 친구 요청을 보낼 수 없습니다.")
                elif FriendRequest.objects.filter(from_user=request.user, to_user=to_user).exists():
                    messages.warning(request, f"{to_user.username}님에게 이미 친구 요청을 보냈습니다.")
                elif Friend.are_friends(request.user, to_user):
                    messages.info(request, f"{to_user.username}님과 이미 친구입니다.")
                else:
                    friend_request = FriendRequest.objects.create(from_user=request.user, to_user=to_user)
                    notification_message = f"{request.user.username}님으로부터 친구 요청이 왔습니다."
                    friend_request.notification_message = notification_message
                    friend_request.save()
                    messages.success(request, f"{to_user.username}님에게 친구 요청을 보냈습니다.")
            except CustomUser.DoesNotExist:
                messages.error(request, "입력한 이메일 주소를 가진 사용자가 없습니다.")
        else:
            messages.error(request, "유효한 이메일을 입력하세요.")
        return redirect('/Accounts/Myfriends/')
    return render(request, 'Mypage/Myfriend.html')

@login_required
def delete_friend(request, friend_id):
    user = request.user
    friend = get_object_or_404(CustomUser, id=friend_id)
    
    # 친구 관계를 제거합니다.
    Friend.lose_friends(user, friend)
    
    messages.success(request, f"{friend.username}님과의 친구 관계가 삭제되었습니다.")
    return redirect('/Accounts/Myfriends/')

@login_required
def my_friends(request):
    user = request.user
    try:
        friend_relationship = Friend.objects.get(current_user=user)
        friends = friend_relationship.users.all()  # 현재 사용자의 친구 목록
    except Friend.DoesNotExist:
        friends = []

    friend_requests = FriendRequest.objects.filter(to_user=request.user)  # 현재 사용자에게 온 친구 요청 목록

    return render(request, 'Mypage/Myfriend.html', {'friends': friends, 'friend_requests': friend_requests})

@login_required
def my_chat_rooms(request):
    user_chat_rooms = ChatRoom.objects.filter(participants=request.user)
    return render(request, 'Mypage/Mychat.html', {'user_chat_rooms': user_chat_rooms})

@login_required
def my_reservation(request):
    hotel_reservations = HotelReservation.objects.filter(user=request.user)
    travel_reservations = TravelReservation.objects.filter(user=request.user)
    return render(request, 'Mypage/Myreservations.html', {
        'hotel_reservations': hotel_reservations,
        'travel_reservations': travel_reservations
    })

@login_required
def reservation_detail(request, reservation_id):
    reservation = get_object_or_404(TravelReservation, id=reservation_id)
    return render(request, 'Mypage/ReservationDetail.html', {'reservation': reservation})

@login_required
def reservation_delete(request, reservation_id):
    reservation = get_object_or_404(TravelReservation, id=reservation_id)
    if request.method == 'POST' and reservation.user == request.user:
        reservation.delete()
        messages.success(request, "예약이 성공적으로 삭제되었습니다.")
        return redirect('Accounts:my_reservations')
    else:
        return HttpResponseForbidden("이 예약을 삭제할 권한이 없습니다.")

def my_post(request):
    user_posts = Post.objects.filter(author=request.user)

    context = {
        'user_posts': user_posts
    }
    return render(request, 'Mypage/Mypost.html', context)

@login_required
def accept_invite(request, invite_id):
    invite = get_object_or_404(FriendRequest, id=invite_id)
    if invite.to_user == request.user:
        invite.accept()
        messages.success(request, "초대를 수락했습니다.")
    else:
        messages.error(request, "이 초대를 수락할 권한이 없습니다.")
    return redirect('/Accounts/Myfriends/')

@login_required
def reject_invite(request, invite_id):
    invite = get_object_or_404(FriendRequest, id=invite_id)
    if invite.to_user == request.user:
        invite.reject()
        messages.success(request, "초대를 거절했습니다.")
    else:
        messages.error(request, "이 초대를 거절할 권한이 없습니다.")
    return redirect('/Accounts/Myfriends/')

@login_required
def reservation_page(request, package_id):
    package = Package.objects.get(id=package_id)
    if request.method == 'POST':
        adult_count = int(request.POST.get('adult_count', 0))
        youth_count = int(request.POST.get('youth_count', 0))
        child_count = int(request.POST.get('child_count', 0))
        total_price = (adult_count * package.adult_price) + (youth_count * package.youth_price) + (child_count * package.child_price)
        
        reservation = Reservation.objects.create(
            user=request.user,
            package=package,
            adult_count=adult_count,
            youth_count=youth_count,
            child_count=child_count,
            total_price=total_price
        )
        return redirect('Accounts:my_reservations')
    return render(request, 'reservation/package.html', {'package': package})
