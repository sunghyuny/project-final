from django import forms
from .models import RegionCategory, TouristSpot

class TouristSpotForm(forms.ModelForm):
    RegionCategory = [
        ('경주'),

    ]


    class Meta:
        model = TouristSpot
        fields = ['name', 'description', 'location', 'region_category', 'image']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # 'region_category' 필드의 선택지를 데이터베이스에서 동적으로 가져오도록 설정합니다.
        self.fields['region_category'].queryset = RegionCategory.objects.all()
