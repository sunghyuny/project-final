// SignUp.js
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const SignUpForm = () => {
  const [formData, setFormData] = useState({
    username: '',
    age: '',
    email: '',
    mbti: '',
    gender: '',
    password: '',
  });

  const [csrfToken, setCsrfToken] = useState('');
  const [isSignUpSuccess, setIsSignUpSuccess] = useState(false);

  const navigate = useNavigate();

  useEffect(() => {
    const getCSRFToken = async () => {
      try {
        const response = await axios.get('/Accounts/csrf/');
        setCsrfToken(response.data.csrfToken);
      } catch (error) {
        console.error('CSRF 토큰 가져오기 실패:', error);
      }
    };

    getCSRFToken();
  }, []);

  const handleChange = (e) => {
    setFormData((prevData) => ({ ...prevData, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const response = await axios.post('/Accounts/signup/', formData, {
        headers: {
          'X-CSRFToken': csrfToken,
        },
        withCredentials:(true),
      });
      console.log('회원가입 성공:', response.data);
      setIsSignUpSuccess(true);
    } catch (error) {
      console.error('회원가입 실패:', error);
    }
  };

  const handleRedirectHome = () => {
    navigate('/');
  };

  return (
    <div>
      <h1>회원가입</h1>
      <form onSubmit={handleSubmit}>
        <label htmlFor="username">Username:</label>
        <input type="text" id="username" name="username" onChange={handleChange} required /><br />
        
        <label htmlFor="age">Age:</label>
        <input type="text" id="age" name="age" onChange={handleChange} required /><br />

        <label htmlFor="email">Email:</label>
        <input type="email" id="email" name="email" onChange={handleChange} required /><br />

        <label htmlFor="mbti">MBTI:</label>
        <input type="text" id="mbti" name="mbti" onChange={handleChange} required /><br />

        <label htmlFor="gender">Gender:</label>
        <input type="text" id="gender" name="gender" onChange={handleChange} required /><br />

        <label htmlFor="password">Password:</label>
        <input type="password" id="password" name="password" onChange={handleChange} required /><br />

        <button type="submit">회원가입</button>
      </form>

      {isSignUpSuccess && (
        <div>
          <p>회원가입이 성공적으로 완료되었습니다!</p>
          <button onClick={handleRedirectHome}>홈으로 이동</button>
        </div>
      )}
    </div>
  );
};

export default SignUpForm;
