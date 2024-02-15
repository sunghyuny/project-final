import React, {useState} from 'react';
import { Link } from 'react-router-dom';
import '../App.css';
import Menu from './menu.js';

function Navbar(){
    const [showMenu, setShowMenu] = useState(false);

    const toggleMenu =() =>{
        setShowMenu(!showMenu);
    };
    return(
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
            </ul>
            <Link to="/page/Signup" className='nav_btn'><button className='login_btn'>로그인</button></Link>
            {showMenu && <Menu/>}
        </div>
    )
}
export default Navbar