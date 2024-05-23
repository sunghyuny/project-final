from django.urls import path
from .views import chat_room, create_chat_room, join_chat_room, chat_room_list

app_name = 'match'
urlpatterns = [
    path('chat/<int:room_id>/', chat_room, name="chat_room"),
    path('create_chat_room/', create_chat_room, name="create_chat_room"),
    path('join_chat_room/<int:room_id>/', join_chat_room, name="join_chat_room"),
    path('chat_rooms/', chat_room_list, name="chat_room_list"),
]
