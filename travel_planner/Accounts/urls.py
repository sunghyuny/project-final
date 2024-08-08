from django.urls import path, include
from .views import *
from django.contrib.auth import views as auth_views
app_name = 'Accounts'
urlpatterns =[
    path('signup/', signup, name='signup'),
    path('login/', user_login, name='login'),
    path('logout/', logout_view, name='logout'),
    path('mypage/', my_page, name='mypage'),
    path('userplan/', user_plan, name='plan'),
    path('userplan/<int:user_plan_id>/', userplan_detail, name='plan_detail'),
    path('plan/delete/<int:plan_id>/', plan_delete, name='plan_delete'),
    path('send_friend_request/<int:user_id>/', send_friend_request, name='send_friend_request'),
    path('send_friend_request_by_email/', send_friend_request_by_email, name='send_friend_request_by_email'),
    path('accept_friend_request/<int:request_id>/', accept_friend_request, name='accept_friend_request'),
    path('delete_friend_request/<int:request_id>/', delete_friend_request, name='delete_friend_request'),
    path('Myfriends/', my_friends, name='my_friends'),
    path('userplan/<int:plan_id>/edit/', plan_edit, name='plan_edit'),
    path('accept_invite/<int:invite_id>/', accept_invite, name='accept_invite'),
    path('reject_invite/<int:invite_id>/', reject_invite, name='reject_invite'),
    path('my-chats/', my_chat_rooms, name='my_chat_rooms'),
    path('my_reservations/', my_reservation, name='my_reservations'),
    path('my_post/', my_post, name='my_post'),
]




