from django.contrib import admin
from .models import TouristSpot, RegionCategory

# TouristSpot 모델 등록
@admin.register(TouristSpot)
class TouristSpotAdmin(admin.ModelAdmin):
    list_display = ['name', 'description', 'location', 'region_category']
    search_fields = ['name', 'description', 'location']
    list_filter = ['region_category']
    # 필요한 경우 다른 설정을 추가할 수 있습니다.

# RegionCategory 모델 등록
@admin.register(RegionCategory)
class RegionCategoryAdmin(admin.ModelAdmin):
    list_display = ['name']
    search_fields = ['name']

    # 필요한 경우 다른 설정을 추가할 수 있습니다.
