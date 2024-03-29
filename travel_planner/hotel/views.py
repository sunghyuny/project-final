from django.http import HttpResponseRedirect
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from .models import Accommodation


def mainhotel(request):
    return render(request, '')
def accommodation_create_direct(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        photo = request.FILES.get('photo')
        details = request.POST.get('details', '')
        amenities = request.POST.get('amenities', '')
        quantity = request.POST.get('quantity')
        likes = 0  # 초기값 설정

        Accommodation.objects.create(
            name=name, photo=photo, details=details,
            amenities=amenities, quantity=quantity, likes=likes
        )

        return redirect('/')  # 숙소 등록 후 리다이렉트 될 페이지 예: 홈
    return render(request, 'hotel/create.html')

def detail(request, hotel_id): 
    hotel = get_object_or_404(Accommodation, id= hotel_id)
    context = {'hotel': hotel}
    return render(request, 'detail/lodg_detail.html', context)
