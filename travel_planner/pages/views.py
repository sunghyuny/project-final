from django.shortcuts import render
# Create your views here.


def mainpage(requet):

    return render(request, 'pages/home.html')