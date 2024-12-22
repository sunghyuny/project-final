import json

from django.utils import timezone
from django.contrib.auth.decorators import login_required
from django.core.files.storage import default_storage
from django.http import HttpResponseRedirect, HttpResponseForbidden, JsonResponse
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

from Accounts.models import CustomUser
from match.models import ChatRoom, Message
from planner.models import TripPlan


@login_required
def chat_room(request, room_id):
    chat_room = get_object_or_404(ChatRoom, id=room_id)

    user_trip_plans = TripPlan.objects.filter(user=request.user)

    if request.method == 'POST':
        message_content = request.POST.get('message_content')
        if message_content:
            Message.objects.create(chat_room=chat_room, sender=request.user, content=message_content)
            return HttpResponseRedirect(reverse('match:chat_room', args=[room_id]))

    messages = chat_room.messages.all().order_by('timestamp')
    return render(request, 'match/chat.html', {'chat_room': chat_room, 'messages': messages, 'user_trip_plans': user_trip_plans})

@csrf_exempt
@login_required
def invite_to_trip_plan(request):
    if request.method == 'POST':
        trip_plan_id = request.POST.get('trip_plan_id')
        user_id = request.POST.get('user_id')

        try:
            trip_plan = TripPlan.objects.get(id=trip_plan_id)
            user = CustomUser.objects.get(id=user_id)
            trip_plan.friends.add(user)
            trip_plan.save()
            return JsonResponse({'success': True})
        except TripPlan.DoesNotExist:
            return JsonResponse({'success': False, 'error': 'Invalid trip plan ID'})
        except CustomUser.DoesNotExist:
            return JsonResponse({'success': False, 'error': 'Invalid user ID'})
    else:
        return JsonResponse({'success': False, 'error': 'Invalid request method'})

@login_required
def create_chat_room(request):
    if request.method == 'POST':
        room_name = request.POST.get('room_name')
        capacity = request.POST.get('room_capacity')
        location = request.POST.get('room_location')
        departure_date = request.POST.get('departure_date')
        arrival_date = request.POST.get('arrival_date')
        description = request.POST.get('description')
        image = request.FILES.get('room_image')

        if room_name and capacity and location and departure_date and arrival_date:
            try:
                capacity = int(capacity)  # capacity 값을 정수형으로 변환
            except ValueError:
                # 유효하지 않은 capacity 값 처리 (예: 정수가 아닌 값이 입력된 경우)
                return render(request, 'match/create_chat_room.html', {'error': '유효한 인원 수를 입력해 주세요.'})

            chat_room = ChatRoom.objects.create(
                name=room_name,
                creator=request.user,
                capacity=capacity,
                location=location,
                date=timezone.now().date(),  # 현재 날짜로 설정
                departure_date=departure_date,
                arrival_date=arrival_date,
                description=description
            )
            if image:
                chat_room.image = image

            chat_room.save()

            chat_room.participants.add(request.user)
            if chat_room.is_full:
                chat_room.status = 'completed'
                chat_room.save()
            return HttpResponseRedirect(reverse('match:chat_room_list'))

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

@login_required
def chat_room_detail(request, room_id):
    chat_room = get_object_or_404(ChatRoom, id=room_id)

    if ChatRoom.status=='complited':
        return JsonResponse({"이미 방에 들어가있습니다."}, status = 403)
    if request.user in chat_room.participants.all():
        return redirect('match:chat_room', room_id=room_id)
    else:
        return render(request, 'match/chat_detail.html', {'room': chat_room})


@login_required
def delete_chat_room(request, room_id):
    chat_room = get_object_or_404(ChatRoom, id=room_id)
    if request.user == chat_room.creator:
        chat_room.delete()
        return redirect('Accounts:my_chat_rooms')
    else:
        return HttpResponseForbidden("You are not allowed to delete this chat room.")

@csrf_exempt
def change_chat_room_status(request, room_id):
    if request.method == 'POST':
        try:
            room = ChatRoom.objects.get(id=room_id)
            data = json.loads(request.body)
            new_status = data.get('status')
            if new_status in [choice[0] for choice in room.STATUS_CHOICES]:
                room.status = new_status
                room.save()
                return JsonResponse({
                    'success': True,
                    'new_status_display': room.get_status_display()
                })
        except ChatRoom.DoesNotExist:
            return JsonResponse({'success': False, 'error': '채팅방을 찾을 수 없습니다.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})
    return JsonResponse({'success': False, 'error': '잘못된 요청입니다.'})