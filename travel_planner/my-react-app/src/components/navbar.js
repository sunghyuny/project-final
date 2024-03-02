import React, { useState, useContext } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios'; // axios import 추가
import '../App.css';
import Menu from './menu.js';
import UserContext from './UserContext';

function Navbar() {
    const [showMenu, setShowMenu] = useState(false);
    const userContext = useContext(UserContext); // UserContext 가져오기

    const toggleMenu = () => {
        setShowMenu(!showMenu);
    };

    const handleLogout = async () => { // async 키워드 추가
        try {
            const response = await axios.post('/Accounts/logout/'); // 로그아웃 요청 보내기
            console.log(response.data); // 로그아웃 성공 시 응답 확인
            userContext.setUser(null); // 로그아웃 성공 시 UserContext 업데이트
        } catch (error) {
            console.error('Error logging out:', error); // 로그아웃 실패 시 에러 처리
        }
    };

    return (
        <div className="navbar">
            <Link to="/" className='Logo_link'><div className="logo">Travel Plan</div></Link>
            <input type='text' placeholder='검색할 내용을 입력하세요' className='seach_text'></input>
            <ul>
                <li onClick={toggleMenu}>전체 메뉴</li>
                <li>여행</li>
                <li><Link to="/planner/schedule" className='nav_link'>여행 계획</Link></li>
                <li>숙박</li>
                <li>관광지</li>
                <li>커뮤니티</li>
                <li>매칭</li>
                <li><Link to="/thesights/touristspots">관광지 등록</Link></li>
            </ul>
            {userContext.user ? (
                <div>
                    {userContext.user.username} 님 {/* 사용자 이름 표시 */}
                    <button onClick={handleLogout} className='logout_btn'>로그아웃</button>
                </div>
            ) : (
                <Link to="/Accounts/login" className='nav_btn'><button className='login_btn'>로그인</button></Link>
            )}
            {showMenu && <Menu/>}
        </div>
    );
}

export default Navbar;
