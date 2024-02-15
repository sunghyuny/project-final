<<<<<<< HEAD
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
=======
import React, {useState} from 'react';
import Menu from './menu';
import { Link } from 'react-router-dom';
>>>>>>> e58833f4e11e4f16f70ca1dbf23e08a4f51cf9d3

function Navbar() {
    const [isLoggedIn, setIsLoggedIn] = useState(false);
    const [username, setUsername] = useState('');
    const navigate = useNavigate();

    const handleLogin = async () => {
        try {
            // 로그인 처리 로직을 구현합니다.
            // 로그인에 성공하면 사용자 정보를 받아와서 상태를 업데이트합니다.
            const response = await axios.post('http://localhost:8000/Accounts/login/', { username });
            setUsername(response.data.username);
            setIsLoggedIn(true);
            navigate('/');
        } catch (error) {
            console.error('Login Failed:', error);
        }
    };

    const handleLogout = () => {
        // 로그아웃 처리 로직을 구현합니다.
        // 로그아웃에 성공하면 상태를 업데이트합니다.
        setIsLoggedIn(false);
        setUsername('');
    };

    return (
        <div className="navbar">
            <div className="logo">Travel Plan</div>
            <input type='text' placeholder='검색할 내용을 입력하세요'></input>
            <ul>
                <li>전체 메뉴</li>
                <li>여행</li>
                <li>여행 계획</li>
                <li>매칭</li>
                <li>숙소</li>
                <li>관광지</li>
                <li>커뮤니티</li>
            </ul>
<<<<<<< HEAD
            {isLoggedIn ? (
                <div>
                    <p>{username}님</p>
                    <button onClick={handleLogout}>로그아웃</button>
                </div>
            ) : (
                <button onClick={handleLogin}>로그인</button>
            )}
=======
            <Link to="/Accounts/signup"><button>로그인</button></Link>
            {showMenu && <Menu/>}
>>>>>>> e58833f4e11e4f16f70ca1dbf23e08a4f51cf9d3
        </div>
    );
}

export default Navbar;
