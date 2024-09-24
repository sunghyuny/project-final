from django.contrib.auth.decorators import login_required, user_passes_test
from django.http import JsonResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from .models import Package, Reservation, Traveler
from hotel.models import Accommodation
from thesights.models import RegionCategory

# Create your views here.

def package(request):
    packages = Package.objects.all()
    return render(request, 'Tour/package.html', {'packages': packages})

@login_required
@user_passes_test(lambda u: u.is_staff)
def create_package(request):
    if request.method == 'POST':
        accommodation = get_object_or_404(Accommodation, id=request.POST['accommodation_id'])
        region_category = get_object_or_404(RegionCategory, id=request.POST['region_category_id'])
        package = Package(
            destination=request.POST['destination'],
            start_date=request.POST['start_date'],
            end_date=request.POST['end_date'],
            adult_price=request.POST['adult_price'],
            youth_price=request.POST['youth_price'],
            child_price=request.POST['child_price'],
            image=request.FILES['image'],
            accommodation=accommodation,
            accommodation_price=request.POST['accommodation_price'],
            region_category=region_category
        )
        package.save()
        return redirect('/travel/')
    accommodations = Accommodation.objects.all()
    region_categories = RegionCategory.objects.all()
    return render(request, 'Tour/package_create.html', {'accommodations': accommodations, 'region_categories': region_categories})

def package_detail(request, package_id):
    package = get_object_or_404(Package, id=package_id)
    context = {'package': package}
    return render(request, 'detail/package.html', context)

@login_required
def reservation_page(request, package_id):
    package = get_object_or_404(Package, id=package_id)

    context = {
        'package': package,
        'total_price': package.adult_price + package.youth_price + package.child_price + package.accommodation_price
    }
    return render(request, 'reservation/package.html', context)

@login_required
def submit_reservation(request, package_id):
    if request.method == 'POST':
        # 예약 정보 저장
        reservation = Reservation.objects.create(
            user=request.user,
            package_id=package_id,
            adult_count=request.POST['adult'],
            youth_count=request.POST['student'],
            child_count=request.POST['child'],
            total_price=request.POST['total_price']
        )
        
        # 여행자 정보 저장
        copyNum = int(request.POST.get('copyNum', 1))  # copyNum 값을 폼에서 받아옴
        for i in range(copyNum):
            name = request.POST.get(f'traveler_name{i}')
            phone = request.POST.get(f'traveler_phone{i}')
            if name and phone:
                Traveler.objects.create(
                    reservation=reservation,
                    name=name,
                    phone=phone
                )
        
        return redirect('mainpage')
    return render(request, 'reservation/package.html')

def reservation_complete(request):
    return render(request, 'reservation/reservation_success.html')


