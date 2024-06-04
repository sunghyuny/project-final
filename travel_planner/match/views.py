from django.contrib.auth.decorators import login_required
from django.core.files.storage import default_storage
from django.http import HttpResponseRedirect
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from Accounts.models import CustomUser
from match.models import ChatRoom, Message

@login_required
def chat_room(request, room_id):
    chat_room = get_object_or_404(ChatRoom, id=room_id)

    if request.method == 'POST':
        message_content = request.POST.get('message_content')
        if message_content:
            Message.objects.create(chat_room=chat_room, sender=request.user, content=message_content)
            return HttpResponseRedirect(reverse('match:chat_room', args=[room_id]))

    messages = chat_room.messages.all().order_by('timestamp')
    return render(request, 'match/chat.html', {'chat_room': chat_room, 'messages': messages})


@login_required
def create_chat_room(request):
    if request.method == 'POST':
        room_name = request.POST.get('room_name')
        capacity = request.POST.get('room_capacity')
        location = request.POST.get('room_location')
        date = request.POST.get('room_date')
        description = request.POST.get('description')
        image = request.FILES.get('room_image')

        if room_name and capacity and location and date:
            chat_room = ChatRoom.objects.create(
                name=room_name,
                creator=request.user,
                capacity=capacity,
                location=location,
                date=date,
                description=description
            )
            if image:
                chat_room.image = image
                chat_room.save()

            chat_room.participants.add(request.user)
<<<<<<< HEAD
            return HttpResponseRedirect(reverse('match:chat_room_list'))  # 채팅방 리스트 페이지로 리다이렉트
=======
            return HttpResponseRedirect(reverse('match:chat_room_list'))
>>>>>>> 2976fe564108a6dc8c3f300b81639979fd23717f

    return render(request, 'match/create_chat_room.html')

@login_required
def join_chat_room(request, room_id):
    chat_room = get_object_or_404(ChatRoom, id=room_id)
    chat_room.participants.add(request.user)
    return redirect('match:chat_room', room_id=room_id)


@login_required
def chat_room_list(request):
    chat_rooms = ChatRoom.objects.all()
    return render(request, 'match/chat_room_list.html', {'chat_rooms': chat_rooms})

<<<<<<< HEAD
=======

>>>>>>> 2976fe564108a6dc8c3f300b81639979fd23717f
@login_required
def chat_room_detail(request, room_id):
    chat_room = get_object_or_404(ChatRoom, id=room_id)
    if request.user in chat_room.participants.all():
        return redirect('match:chat_room', room_id=room_id)
    else:
        return render(request, 'match/chat_detail.html', {'room': chat_room})
