import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const Login = () => {
    const [formData, setFormData] = useState({
        username: '',
        password: ''
    });
    const [username, setUsername] = useState(''); // 사용자 이름 상태 추가

    const navigate = useNavigate();

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const response = await axios.post('http://localhost:8000/Accounts/login/', formData);
            console.log(response.data);
            // Handle login success, e.g., redirect to dashboard
            navigate('/');
            setUsername(response.data.username); // 받은 사용자 이름을 상태에 저장
        } catch (error) {
            console.error('Login Failed:', error);
            // Handle login failure, e.g., show error message
        }
    };

    return (
        <div>
            <h1>Login</h1>
            <form onSubmit={handleSubmit}>
                <label>Username:</label>
                <input type="text" name="username" value={formData.username} onChange={handleChange} />
                <label>Password:</label>
                <input type="password" name="password" value={formData.password} onChange={handleChange} />
                <button type="submit">Login</button>
            </form>
        </div>
    );
};

export default Login;
