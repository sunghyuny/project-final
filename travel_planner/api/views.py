from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
import json
from django.core.serializers import serialize
from django.core.exceptions import ObjectDoesNotExist
from django.shortcuts import get_object_or_404
from Accounts.models import Friend
from .models import *
from hotel.models import *
from thesights.models import *
from planner.models import *
import logging
from django.middleware.csrf import get_token
from django.views.decorators.http import require_http_methods
logger = logging.getLogger(__name__)


def homepage_view(request):
    accommodations = Accommodation.objects.all()
    data = []

    for accommodation in accommodations:
        data.append({
            'id': accommodation.id,  # 반드시 id 필드를 포함시킵니다.
            'name': accommodation.name,
            'photo': request.build_absolute_uri(accommodation.photo.url).replace('/media//', '/media/'),
            'price': accommodation.price,
        })

    return JsonResponse({'accommodations': data}, status=200)


@login_required
@csrf_exempt
def trip_plan_form(request):
    user = request.user
    try:
        friends = Friend.objects.get(current_user=user).users.all()
    except Friend.DoesNotExist:
        friends = CustomUser.objects.none()

    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            arrival_date = data.get('arrival_date')
            departure_date = data.get('departure_date')
            adults = int(data.get('adults', 0))
            teens = int(data.get('teens', 0))
            children = int(data.get('children', 0))
            total_people = adults + teens + children
            friend_ids = data.get('friends', [])

            # TripPlan 생성
            trip_plan = TripPlan.objects.create(
                arrival_date=arrival_date,
                departure_date=departure_date,
                total_people=total_people,
                user=user
            )

            trip_plan.friends.set(friend_ids)
            trip_plan.save()

            # 세션에 트립 플랜 ID를 저장하여 이후에 사용 가능하도록 처리
            request.session['trip_plan_id'] = trip_plan.id
            request.session['adults'] = adults
            request.session['teens'] = teens
            request.session['children'] = children

            # 트립 플랜 ID와 함께 성공적으로 생성되었음을 반환
            return JsonResponse({'message': 'Trip plan created successfully', 'trip_plan_id': trip_plan.id}, status=201)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)


    return JsonResponse({'error': 'Invalid request method'}, status=405)
@login_required
@csrf_exempt
def location(request):
    trip_plan_id = request.session.get('trip_plan_id')
    if not trip_plan_id:
        return JsonResponse({'error': 'Session does not contain trip plan information'}, status=400)

    try:
        trip_plan = TripPlan.objects.get(id=trip_plan_id)
    except TripPlan.DoesNotExist:
        return JsonResponse({'error': 'Trip plan does not exist'}, status=404)

    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            destination = data.get('destination')
            if not destination:
                return JsonResponse({'error': 'Missing destination'}, status=400)

            trip_plan.destination = destination
            trip_plan.save()
            return JsonResponse({'message': 'Destination updated successfully'}, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def plan2(request):
    trip_plan_id = request.session.get('trip_plan_id')
    print(f'Received trip_plan_id from session: {trip_plan_id}')
    if not trip_plan_id:
        return JsonResponse({'error': 'Session does not contain trip plan information'}, status=400)

    try:
        trip_plan = TripPlan.objects.get(id=trip_plan_id)
    except TripPlan.DoesNotExist:
        return JsonResponse({'error': 'Trip plan does not exist'}, status=404)

    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            selected_accommodation_id = data.get('accommodation_id')
            print(f'Received accommodation_id from request: {selected_accommodation_id}')

            selected_accommodation = Accommodation.objects.get(pk=selected_accommodation_id)
            trip_plan.selected_accommodation = selected_accommodation
            trip_plan.save()
            return JsonResponse({'message': 'Accommodation selected successfully'}, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
@require_http_methods(["GET", "POST"])
def activity_view(request):
    if request.method == 'GET':
        activities = Activity.objects.all()
        activities_data = [
            {
                'id': activity.id,
                'name': activity.name,
                'photo': request.build_absolute_uri(activity.photo.url),
                'category': activity.category.name,
            }
            for activity in activities
        ]
        return JsonResponse({'activities': activities_data}, status=200)

    elif request.method == 'POST':
        try:
            data = json.loads(request.body)
            activity_id = data.get('activity_id')
            trip_plan_id = data.get('trip_plan_id')

            if not trip_plan_id:
                return JsonResponse({'error': 'Trip plan ID is missing'}, status=400)

            try:
                trip_plan = TripPlan.objects.get(id=trip_plan_id)
            except TripPlan.DoesNotExist:
                return JsonResponse({'error': 'Trip plan does not exist'}, status=404)

            try:
                activity = Activity.objects.get(id=activity_id)
                trip_plan.selected_activity.add(activity)
                trip_plan.save()
                return JsonResponse({'message': 'Activity selected successfully'}, status=200)
            except Activity.DoesNotExist:
                return JsonResponse({'error': 'Activity does not exist'}, status=404)

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)
 
@csrf_exempt
def plan4(request, trip_plan_id):
    try:
        trip_plan = TripPlan.objects.get(id=trip_plan_id)
    except TripPlan.DoesNotExist:
        return JsonResponse({'error': 'Trip plan does not exist'}, status=404)

    total_activity_cost = sum(int(activity.price) for activity in trip_plan.selected_activity.all())

    response_data = {
        'trip_plan': {
            'arrival_date': trip_plan.arrival_date,
            'departure_date': trip_plan.departure_date,
            'destination': trip_plan.destination,
            'selected_accommodation': trip_plan.selected_accommodation.name if trip_plan.selected_accommodation else None,
            'selected_activities': list(trip_plan.selected_activity.values('name', 'price')),
            'total_people': trip_plan.total_people,
            'total_activity_cost': total_activity_cost,
        },
    }

    return JsonResponse(response_data, status=200)
def get_csrf_token(request):
    csrf_token = get_token(request)
    return JsonResponse({'csrfToken': csrf_token})

@login_required
def get_user_info(request):
    user = request.user
    response_data = {
        'username': user.username,
        'email': user.email,
    }
    return JsonResponse(response_data)

def accommodations_view(request):
    accommodations = Accommodation.objects.all()
    data = []

    for accommodation in accommodations:
        data.append({
            'id': accommodation.id,  # 반드시 id 필드를 포함시킵니다.
            'name': accommodation.name,
            'photo': request.build_absolute_uri(accommodation.photo.url).replace('/media//', '/media/'),
            'price': accommodation.price,
        })

    return JsonResponse({'accommodations': data}, status=200)
def flutter_signup(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data.get('username')
        password = data.get('password')
        email = data.get('email')
        age = data.get('age')
        mbti = data.get('mbti')
        gender = data.get('gender')

        if username and password and email and age and mbti and gender:
            user = CustomUser.objects.create_user(
                username=username, password=password, email=email, age=age, mbti=mbti, gender=gender
            )
            return JsonResponse({'message': '회원가입이 성공적으로 완료되었습니다.'}, status=200)
        else:
            return JsonResponse({'error': '입력이 올바르지 않습니다. 모든 필드를 채워주세요.'}, status=400)
    return JsonResponse({'error': 'GET 요청은 허용되지 않습니다.'}, status=405)


def get_csrf_token(request):
    csrf_token = get_token(request)
    return JsonResponse({'csrfToken': csrf_token})
@csrf_exempt
def flutter_login(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data.get('email')
        password = data.get('password')
        user = authenticate(request, username=email, password=password)
        if user is not None:
            login(request, user)
            # 리디렉션 없이 JSON으로 응답
            return JsonResponse({'message': 'Login successful'}, status=200)
        else:
            return JsonResponse({'error': 'Invalid username or password.'}, status=400)
    return JsonResponse({'error': 'GET 요청은 허용되지 않습니다.'}, status=405)
 
@csrf_exempt
def flutter_logout(request):
    if request.method == 'POST':
        logout(request)
        request.session.flush()  # 세션 명시적 삭제
        return JsonResponse({'message': '로그아웃 성공'}, status=200)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

def user_info(request):
    user = request.user
    if user.is_authenticated:
        context = {
            'username': user.username,
            'email': user.email,
        }
        return JsonResponse(context)
    else:
        return JsonResponse({'error': 'User not authenticated'}, status=401)