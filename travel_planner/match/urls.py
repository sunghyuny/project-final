from django.urls import path
from .views import *

app_name = 'match'
urlpatterns = [
    path('chat/<int:room_id>/', chat_room, name="chat_room"),
    path('create_chat_room/', create_chat_room, name="create_chat_room"),
    path('join_chat_room/<int:room_id>/', join_chat_room, name="join_chat_room"),
    path('', chat_room_list, name="chat_room_list"),
    path('chat/detail/<int:room_id>/', chat_room_detail, name='chat_room_detail'),
    path('delete-chat-room/<int:room_id>/', delete_chat_room, name='delete_chat_room'),

]
