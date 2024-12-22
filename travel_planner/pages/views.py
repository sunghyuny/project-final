from django.shortcuts import render
from thesights.models import *
from Accounts.models import CustomUser
from django.utils import timezone
from datetime import timedelta
from hotel.models import Accommodation
from planner.models import Activity
from post.models import Post
from thesights.models import RegionCategory, TouristSpot
from match.models import ChatRoom
from django.utils.dateformat import DateFormat
from travel.models import Package
from django.http import JsonResponse
from django.core.paginator import Paginator
# Create your views here.


def mainpage(request):
    region_categories = RegionCategory.objects.all()
    tourist_spots = TouristSpot.objects.all()
    return render(request, 'pages/home.html', {'region_categories': region_categories, 'tourist_spots': tourist_spots})



def flutter_mainpage(request):
    # 지역 카테고리와 관광지 데이터
    region_categories = list(RegionCategory.objects.values())
    tourist_spots = list(TouristSpot.objects.values())

    # 숙소 데이터
    accommodations = list(Accommodation.objects.values())

    return JsonResponse({
        'region_categories': region_categories,
        'tourist_spots': tourist_spots,
        'accommodations': accommodations,  # 숙소 데이터 추가
    })

def admin_main(request):
    users = CustomUser.objects.all()  # 모든 사용자 불러오기
    today_users = users.filter(date_joined__gte=timezone.now() - timedelta(days=1))
    week_users = users.filter(date_joined__gte=timezone.now() - timedelta(days=7))
    month_users = users.filter(date_joined__gte=timezone.now() - timedelta(days=30))
    three_month_users = users.filter(date_joined__gte=timezone.now() - timedelta(days=90))
    accommodations = Accommodation.objects.all()  # 모든 숙소 불러오기
    activities = Activity.objects.all()  # 모든 활동 불러오기
    posts = Post.objects.all()  # 모든 게시물 불러오기
    region_categories = RegionCategory.objects.all()
    tourist_spots = TouristSpot.objects.all()

    # 사용자 프로필 사진을 포함하여 context에 추가
    user_profiles = users.values('id', 'profile_picture')
    user_profiles_list = list(user_profiles)

    context = {
        'users': users,
        'today_users': today_users,
        'week_users': week_users,
        'month_users': month_users,
        'three_month_users': three_month_users,
        'accommodations': accommodations,
        'activities': activities,
        'posts': posts,  # 게시물 추가
        'region_categories': region_categories,
        'tourist_spots': tourist_spots,
        'user_profiles': user_profiles_list,  # 사용자 프로필 사진 추가
    }
    return render(request, 'Admin/Manage_main.html', context    )

def admin_lodg(request):
    accommodations = Accommodation.objects.all()
    accommodation_images = [accommodation.photo.url for accommodation in accommodations]
    
    return render(request, 'Admin/Lodg_manage.html', {'accommodations': accommodations, 'accommodation_images': accommodation_images})

def admin_member(request):
    users = CustomUser.objects.all()
    user_posts = {}
    for user in users:
        user_posts[user] = Post.objects.filter(author=user).count()
    return render(request, 'Admin/member_manage.html', {'users': users, 'user_posts': user_posts})

def admin_trip(request):
    packages = Package.objects.all()
    package_images = [package.image.url for package in packages]
    return render(request, 'Admin/Trip_manage.html', {'packages': packages, 'package_images': package_images})


def admin_active(request):
    activities = Activity.objects.all()
    paginator = Paginator(activities, 10)  # 한 페이지에 10개의 활동을 표시
    page_number = request.GET.get('page')  # URL에서 'page' 파라미터 가져오기
    page_obj = paginator.get_page(page_number)

    activity_images = [activity.photo.url for activity in page_obj]  # 현재 페이지의 활동 이미지들
    categorized_activities = {}
    for activity in page_obj:
        category_id = activity.category.id
        if category_id not in categorized_activities:
            categorized_activities[category_id] = []
        categorized_activities[category_id].append(activity)

    total_pages = paginator.num_pages  # 전체 페이지 수 계산
    return render(request, 'Admin/Active_manage.html', {
        'activities': page_obj,  # 페이지네이션 된 활동 리스트 전달
        'activity_images': activity_images,
        'categorized_activities': categorized_activities,
        'total_pages': total_pages,  # 전체 페이지 수 추가
        'page': page_obj.number  # 현재 페이지 번호 추가
    })


def admin_match(request):
    chat_rooms = ChatRoom.objects.all()
    return render(request, 'Admin/Match_manage.html', {'chat_rooms': chat_rooms})


def admin_post(request):
    posts = Post.objects.all()
    return render(request, 'Admin/Post_manage.html', {'posts': posts})


