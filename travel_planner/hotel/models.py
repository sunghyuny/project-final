from django.db import models

class Accommodation(models.Model):
    name = models.CharField(max_length=100)
    photo = models.ImageField(upload_to='accommodations_photos/')
    price = models.TextField()
    details = models.TextField()
    amenities = models.TextField()
    quantity = models.IntegerField()
    likes = models.PositiveIntegerField(default=0)

    def __str__(self):
        return self.name
