from django.middleware.csrf import get_token
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import TouristSpot, RegionCategory
from .serializers import TouristSpotSerializer, RegionCategorySerializer
from django.views.decorators.csrf import csrf_exempt


@api_view(['GET'])
def get_csrf_token(request):
    if request.method == 'GET':
        csrf_token = get_token(request)
        return Response({'csrf_token': csrf_token})

@api_view(['POST', 'GET'])
def create_tourist_spot(request):
    # 요청 데이터에서 필드들을 가져옵니다.
    name = request.data.get('name')
    description = request.data.get('description')
    location = request.data.get('location')
    category_name = request.data.get('region_category')

    # 필수 필드들이 모두 존재하는지 확인합니다.
    if not all([name, description, location, category_name]):
        return Response({'error': 'All fields are required.'}, status=status.HTTP_400_BAD_REQUEST)

    # 'region_category'를 가져오거나 새로 생성합니다.
    category, created = RegionCategory.objects.get_or_create(name=category_name)

    # 시리얼라이저에 전달할 데이터를 생성합니다.
    serializer_data = {
        'name': name,
        'description': description,
        'location': location,
        'region_category': category.id
    }

    # 시리얼라이저를 생성합니다.
    serializer = TouristSpotSerializer(data=serializer_data)

    # 시리얼라이저의 유효성을 검사합니다.
    if serializer.is_valid():
        # 유효한 경우 시리얼라이저를 저장합니다.
        serializer.save()
        # 성공 응답을 반환합니다.
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    else:
        # 유효하지 않은 경우 에러 응답을 반환합니다.
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
