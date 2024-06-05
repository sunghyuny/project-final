from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect, get_object_or_404
from travel.models import *


# Create your views here.


def package(request):
    packages = Package.objects.all()
    return render(request, 'Tour/package.html', {'packages': packages})
@login_required
def create_package(request):
    if request.method == 'POST':
        destination = request.POST['destination']
        start_date = request.POST['start_date']
        end_date = request.POST['end_date']
        price = request.POST['price']
        image = request.FILES['image']  # 파일 업로드 처리

        package = Package(destination=destination, start_date=start_date, end_date=end_date, price=price, image=image)
        package.save()
        return redirect('/travel/')
    return render(request, 'Tour/package_create.html')


def reservation_page(request, package_id):
    package = get_object_or_404(Package, id=package_id)

    if request.method == 'POST':
        adult_count = int(request.POST.get('adult_count', 0))
        youth_count = int(request.POST.get('youth_count', 0))
        child_count = int(request.POST.get('child_count', 0))

        total_price = package.price * (adult_count + youth_count + child_count)

        context = {
            'package': package,
            'adult_count': adult_count,
            'youth_count': youth_count,
            'child_count': child_count,
            'total_price': total_price,
        }
        return render(request, 'reservation/package.html', context)

    return render(request, 'detail/package.html', {'package': package})

def package_detail(request, package_id):
    package = get_object_or_404(Package, id=package_id)
    context = {'package': package}
    return render(request, 'detail/package.html', context)


