from django.db import models
from thesights.models import RegionCategory
class Accommodation(models.Model):
    name = models.CharField(max_length=100)
    photo = models.ImageField(upload_to='accommodations_photos/')
    price = models.TextField()
    details = models.TextField()
    amenities = models.TextField()
    quantity = models.IntegerField()
    likes = models.PositiveIntegerField(default=0)
    region_category = models.ForeignKey(RegionCategory, on_delete=models.CASCADE)


    def __str__(self):
        return self.name