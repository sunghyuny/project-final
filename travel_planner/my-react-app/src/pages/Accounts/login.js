import React, { useState } from 'react';
import axios from 'axios';

const Login = () => {
    const [formData, setFormData] = useState({
        username: '',
        password: ''
    });

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const response = await axios.post('http://localhost:8000/Accounts/login/', formData);
            console.log(response.data);
            // Handle login success, e.g., redirect to dashboard
        } catch (error) {
            console.error('Login Failed:', error);
            // Handle login failure, e.g., show error message
        }
    };

    return (
        <div className='Login_container'>
            <div className='page_title'>
                <h3>로그인</h3>
                <hr></hr>
            </div>
            <div className='Login_contents'>
                <input type='test' placeholder="아이디"></input><br></br>
                <input type='password' placeholder="비밀번호"></input>
                <button type='submit' className='login_button'>로그인</button>
                <button>회원가입</button>
                <button>아이디/비번찾기</button>
            </div>
        </div>
    );
};

export default Login;
