import React, { useState, useEffect } from 'react';
import axios from 'axios';

const TouristSpotForm = () => {
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    location: '',
    region_category: '',
    image: null
  });
  const [csrfToken, setCsrfToken] = useState('');

  useEffect(() => {
    const fetchCsrfToken = async () => {
      try {
        const response = await axios.get('/thesights/csrftoken/');
        setCsrfToken(response.data.csrf_token);
      } catch (error) {
        console.error('Error fetching CSRF token:', error);
      }
    };
    fetchCsrfToken();
  }, []);

  const handleChange = (e) => {
    if (e.target.name === 'image') {
      setFormData({ ...formData, [e.target.name]: e.target.files[0] });
    } else {
      setFormData({ ...formData, [e.target.name]: e.target.value });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const formDataWithImage = new FormData();
    formDataWithImage.append('name', formData.name);
    formDataWithImage.append('description', formData.description);
    formDataWithImage.append('location', formData.location);
    formDataWithImage.append('region_category', formData.region_category);
    formDataWithImage.append('image', formData.image);

    try {
      await axios.post('/thesights/tourist/', formDataWithImage, {
        headers: {
          'Content-Type': 'multipart/form-data',
          'X-CSRFToken': csrfToken // CSRF 토큰 추가
        }
      });
      alert('Tourist spot added successfully!');
      setFormData({
        name: '',
        description: '',
        location: '',
        region_category: '',
        image: null
      });
    } catch (error) {
      console.error('Error adding tourist spot:', error);
      alert('Failed to add tourist spot!');
    }
  };

  return (
    <div>
      <h2>Add Tourist Spot</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Name:</label>
          <input type="text" name="name" value={formData.name} onChange={handleChange} required />
        </div>
        <div>
          <label>Description:</label>
          <textarea name="description" value={formData.description} onChange={handleChange} required />
        </div>
        <div>
          <label>Location:</label>
          <input type="text" name="location" value={formData.location} onChange={handleChange} required />
        </div>
        <div>
          <label>Region Category:</label>
          <input type="text" name="region_category" value={formData.region_category} onChange={handleChange} required />
        </div>
        <div>
          <label>Image:</label>
          <input type="file" name="image" accept="image/*" onChange={handleChange} required />
        </div>
        <button type="submit">Add Tourist Spot</button>
      </form>
    </div>
  );
};

export default TouristSpotForm;
