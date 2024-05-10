from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from travel.models import Package


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


@login_required
def book_package(request, package_id):
    package = Package.objects.get(id=package_id)
    if request.method == 'POST':
        number_of_people = request.POST['number_of_people']
        booking = Booking(user=request.user, package=package, number_of_people=number_of_people)
        booking.save()
        return redirect('/')
    return render(request, 'book_package.html', {'package': package})