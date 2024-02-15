import React, {useState} from 'react';
import Menu from './menu';
import { Link } from 'react-router-dom';

function Navbar(){
    const [showMenu, setShowMenu] = useState(false);

    const toggleMenu =() =>{
        setShowMenu(!showMenu);
    };
    return(
        <div className="navbar">
            <div className="logo">Travel Plan</div>
            <input type='text' placeholder='검색할 내용을 입력하세요'></input>
            <ul>
                <li onClick={toggleMenu}>전체 메뉴</li>
                <li>여행</li>
                <li>여행 계획</li>
                <li>매칭</li>
                <li>숙소</li>
                <li>관광지</li>
                <li>커뮤니티</li>
            </ul>
            <Link to="/Accounts/signup"><button>로그인</button></Link>
            {showMenu && <Menu/>}
        </div>
    )
}
export default Navbar