from django.shortcuts import render

# Create your views here.
def package(request):
    return render(request, 'Tour/package.html')