from django.http import HttpResponseRedirect
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from .models import Accommodation, HotelReservation as HotelReservation
from thesights.models import RegionCategory
from travel.models import Reservation as TravelReservation
from django.contrib.auth.decorators import login_required

def mainhotel(request):
    accommodations = Accommodation.objects.all()
    return render(request, 'Lodging/hotel.html', {'accommodations': accommodations})

def accommodation_create(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        photo = request.FILES.get('photo')
        price = request.POST.get('price')
        details = request.POST.get('details', '')
        amenities = request.POST.get('amenities', '')
        quantity = request.POST.get('quantity')
        region_name = request.POST.get('region_name')

        # 지역 이름으로 해당 지역을 찾습니다.
        try:
            region = RegionCategory.objects.get(name=region_name)
        except RegionCategory.DoesNotExist:
               # 지역이 존재하지 않는 경우 처리할 코드를 여기에 추가합니다.
            pass

        # 숙소를 생성합니다.
        accommodation = Accommodation.objects.create(
            name=name, photo=photo, details=details, price=price,
            amenities=amenities, quantity=quantity, region_category=region
        )

        return redirect('/')  # 숙소 등록 후 리다이렉트될 페이지를 지정합니다. (예: 홈)
    # GET 요청인 경우 숙소 등록 폼을 표시합니다.
    return render(request, 'hotel/create.html', {'regions': RegionCategory.objects.all()})

def hotel_detail(request, hotel_id):
    hotel = get_object_or_404(Accommodation, id=hotel_id)
    context = {'hotel': hotel}
    return render(request, 'detail/lodg_detail.html', context)

@login_required
def reserve_accommodation(request, accommodation_id):
    accommodation = get_object_or_404(Accommodation, id=accommodation_id)
    if request.method == 'POST':
        check_in = request.POST.get('check_in')
        check_out = request.POST.get('check_out')
        guests = request.POST.get('guests')

        reservation = HotelReservation.objects.create(
            user=request.user,
            accommodation=accommodation,
            check_in=check_in,
            check_out=check_out,
            guests=guests
        )
        return render(request, 'hotel/reserve.html', {
            'accommodation': accommodation,
            'success': True
        })
    
    return render(request, 'hotel/reserve.html', {'accommodation': accommodation})

def reservation_success(request, reservation_id):
    reservation = get_object_or_404(HotelReservation, id=reservation_id)
    return render(request, 'hotel/reservation_success.html', {'reservation': reservation})

@login_required
def my_reservation(request):
    hotel_reservations = HotelReservation.objects.filter(user=request.user)
    travel_reservations = TravelReservation.objects.filter(user=request.user)
    return render(request, 'Mypage/Myreservations.html', {
        'hotel_reservations': hotel_reservations,
        'travel_reservations': travel_reservations
    })