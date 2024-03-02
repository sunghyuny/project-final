from rest_framework import serializers
from .models import TouristSpot, RegionCategory

class RegionCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = RegionCategory
        fields = ['id', 'name']

class TouristSpotSerializer(serializers.ModelSerializer):
    region_category = RegionCategorySerializer()  # 중첩된 시리얼라이저 사용

    class Meta:
        model = TouristSpot
        fields = ['id', 'name', 'description', 'location', 'region_category', 'image']
