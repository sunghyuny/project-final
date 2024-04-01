# models.py

from django.db import models

class RegionCategory(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class TouristSpot(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    location = models.CharField(max_length=255)
    region_category = models.ForeignKey(RegionCategory, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='tourist_spots/', blank=True, null=True)
