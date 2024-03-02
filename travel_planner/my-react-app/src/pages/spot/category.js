
// CategoryForm.js

import React, { useState } from 'react';
import axios from 'axios';

const CategoryForm = ({ onCategoryAdded }) => {
  const [name, setName] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('/create_region_category/', { name });
      onCategoryAdded(response.data);
      setName('');
    } catch (error) {
      console.error('Error adding category:', error);
    }
  };

  return (
    <div>
      <h2>Add Category</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Name:</label>
          <input type="text" value={name} onChange={(e) => setName(e.target.value)} required />
        </div>
        <button type="submit">Add Category</button>
      </form>
    </div>
  );
};

export default CategoryForm;
