import React, { useState, useContext } from 'react';
import axios from 'axios';
import { useNavigate, Link } from 'react-router-dom';
import UserContext from '../../components/UserContext'; // 수정된 import 경로

const Login = () => {
    const [formData, setFormData] = useState({
        username: '',
        password: ''
    });

    const navigate = useNavigate();
    const userContext = useContext(UserContext); // UserContext 가져오기

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const response = await axios.post('/Accounts/login/', formData);
            if (response.data) {
                const { user, token } = response.data;
                if (user && token) {
                    userContext.setUser(user.username);
                    navigate('/');
                } else {
                    console.error('Login Failed:', 'Invalid response data');
                    // Handle login failure, e.g., show error message
                }
            } else {
                console.error('Login Failed:', 'Empty response data');
                // Handle login failure, e.g., show error message
            }
        } catch (error) {
            console.error('Login Failed:', error.message);
            // Handle login failure, e.g., show error message
        }
    };

    return (
        <div>
            <h1>로그인</h1>
            <form onSubmit={handleSubmit}>
                <label>Username:</label>
                <input type="text" name="username" value={formData.username} onChange={handleChange} />
                <label>Password:</label>
                <input type="password" name="password" value={formData.password} onChange={handleChange} />
                <button type="submit">Login</button>
            </form>
            <Link to="/Accounts/signup/"><button>회원가입</button></Link>
        </div>
    );
};

export default Login;
