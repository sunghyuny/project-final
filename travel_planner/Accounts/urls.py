from django.urls import path, include
from .views import *
from django.contrib.auth import views as auth_views
app_name = 'Accounts'
urlpatterns =[
    path('signup/', signup, name='signup'),
    path('login/', user_login, name='login'),
    path('logout/', logout_view, name='logout'),
    path('mypage/', my_page, name='mypage'),
    path('edit_profile/', edit_profile, name='edit_profile'),  # 새로운 URL 패턴 추가
    path('userplan/', user_plan, name='plan'),
    path('userplan/<int:user_plan_id>/', userplan_detail, name='plan_detail'),
    path('plan/delete/<int:plan_id>/', plan_delete, name='plan_delete'),
    path('send_friend_request/', send_friend_request, name='send_friend_request'),  # 수정된 URL 패턴
    path('Myfriends/', my_friends, name='my_friends'),
    path('userplan/<int:plan_id>/edit/', plan_edit, name='plan_edit'),
    path('accept_invite/<int:invite_id>/', accept_invite, name='accept_invite'),
    path('reject_invite/<int:invite_id>/', reject_invite, name='reject_invite'),
    path('my-chats/', my_chat_rooms, name='my_chat_rooms'),
    path('my_reservations/', my_reservation, name='my_reservations'),
    path('my_post/', my_post, name='my_post'),
    path('accept_friend_request/<int:request_id>/', accept_friend_request, name='accept_friend_request'),  # 새로운 URL 패턴 추가
    path('reject_friend_request/<int:request_id>/', reject_friend_request, name='reject_friend_request'),  # 새로운 URL 패턴 추가
    path('delete_friend/<int:friend_id>/', delete_friend, name='delete_friend'),  # 새로운 URL 패턴 추가
]
