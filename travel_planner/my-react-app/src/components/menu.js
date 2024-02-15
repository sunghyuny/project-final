import React from 'react';
import { Link } from 'react-router-dom';

function Menu(){
    return(
        <div className='menu'>
            <ul>
                <li className='menu_title'>여행</li>
                <hr></hr>
                <li>자유여행</li>
                <li>패키지 여행</li>
            </ul>

            <ul>
                <li className='menu_title'>여행계획</li>
                <hr></hr>
                <li><Link to="/planner/schedule">계획 작성하기</Link></li>
            </ul>

            <ul>
                <li className='menu_title'>숙박</li>
                <hr></hr>
                <li>호텔</li>
                <li>모텔</li>
                <li>민박</li>
                <li>여관</li>
            </ul>

            <ul>
                <li className='menu_title'>관광지</li>
                <hr></hr>
                <li>내륙</li>
                <li>제주도/섬</li>
            </ul>

            <ul>
                <li className='menu_title'>커뮤니티</li>
                <hr></hr>
                <li>게시판</li>
                <li>후기</li>
                <li>공지사항</li>
            </ul>

            <ul>
                <li className='menu_title'>매칭</li>
                <hr></hr>
                <li>실시간 매칭</li>
                <li>동행 매칭</li>
                <li>친구 채팅</li>
            </ul>
        </div>
    )
}
export default Menu