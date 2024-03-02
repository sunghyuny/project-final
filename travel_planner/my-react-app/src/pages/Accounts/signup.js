// SignupForm.js

import React, { useState } from 'react';
import axios from 'axios';

const SignupForm = () => {
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    age: '',
    mbti: '',
    gender: ''
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post('/Accounts/signup/', formData);
      alert('회원가입이 완료되었습니다.');
      // 회원가입 성공 후 리다이렉트 등의 작업 수행
    } catch (error) {
      console.error('Error signing up:', error);
      alert('회원가입에 실패했습니다.');
    }
  };

  return (
    <div>
      <h2>회원가입</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>아이디:</label>
          <input type="text" name="username" value={formData.username} onChange={handleChange} required />
        </div>
        <div>
          <label>이메일:</label>
          <input type="email" name="email" value={formData.email} onChange={handleChange} required />
        </div>
        <div>
          <label>비밀번호:</label>
          <input type="password" name="password" value={formData.password} onChange={handleChange} required />
        </div>
        <div>
          <label>나이:</label>
          <input type="number" name="age" value={formData.age} onChange={handleChange} />
        </div>
        <div>
          <label>MBTI:</label>
          <input type="text" name="mbti" value={formData.mbti} onChange={handleChange} />
        </div>
        <div>
          <label>성별:</label>
          <select name="gender" value={formData.gender} onChange={handleChange}>
            <option value="male">남자</option>
            <option value="female">여자</option>
          </select>
        </div>
        <button type="submit">회원가입</button>
      </form>
    </div>
  );
};

export default SignupForm;
