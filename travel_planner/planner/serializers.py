# serializers.py

from rest_framework import serializers
from .models import TravelPlan   # YourModel은 실제 모델명으로 대체되어야 합니다.

class TravelPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = TravelPlan
        fields = '__all__'

