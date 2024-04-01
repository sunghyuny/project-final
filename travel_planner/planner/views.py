# views.py

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import TravelPlan
from .serializers import TravelPlanSerializer

class TravelPlanAPIView(APIView):
    def get(self, request):
        data = TravelPlan.objects.all()
        serializer = TravelPlanSerializer(data, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = TravelPlanSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
