import React, { useState, useContext } from 'react';
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';
import { UserContext } from '../../components/UserContext'; // UserContext 불러오기

const LoginForm = () => {
  const [formData, setFormData] = useState({
    email: '',
    password: ''
  });
  const navigate = useNavigate();
  const { setUser } = useContext(UserContext); // UserContext 가져오기

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleLogin = async (userData) => {
    try {
      const response = await axios.post('/Accounts/login/', userData);
      alert('로그인 되었습니다.');
  
      // 사용자 정보를 UserContext를 통해 설정
      setUser(response.data.user);
  
      // 로그인 후 메인 페이지로 이동
      navigate('/'); // '/main'은 메인 페이지 경로입니다.
  
      // 사용자 정보를 로컬 스토리지에 저장
      localStorage.setItem('user', JSON.stringify(response.data.user));
    } catch (error) {
      console.error('Error logging in:', error);
      alert('로그인에 실패했습니다.');
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    handleLogin(formData);
  };

  return (
    <div>
      <h2>로그인</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Email:</label>
          <input type="email" name="email" value={formData.email} onChange={handleChange} required />
        </div>
        <div>
          <label>Password:</label>
          <input type="password" name="password" value={formData.password} onChange={handleChange} required />
        </div>
        <button type="submit">로그인</button>
        <Link to="/Accounts/signup/">회원가입</Link>
      </form>
    </div>
  );
};

export default LoginForm;
