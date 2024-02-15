import React from 'react';
import { Link } from 'react-router-dom'
import Navbar from '../../components/navbar';


function Location(){
    return(
        <div>
            <Navbar/>
            <div className="progress">
                <div className='Fill_Circle'>
                    <p>기간/<br></br>인원</p>
                </div>
                <div className='Fill_Circle'>
                    <p>여행지</p>
                </div>
                <div className='Circle'>
                    <p>숙소</p>
                </div>
                <div className='Circle'>
                    <p>활동</p>
                </div>
                <div className='Circle'>
                    <p>요약</p>
                </div>
            </div>
            <div className='contents'>
                <p className='page_title'>여행지 선택</p>
                <hr></hr>
                 <div className='locate_list'>
                    <ul>
                        <li>서울</li>
                        <li>경기</li>
                        <li>인천</li>
                        <li>전라도</li>
                        <li>경상도</li>
                        <li>충청도</li>
                        <li>강원도</li>
                        <li>제주도</li>
                    </ul>
                 </div>
                 <div className='city_list'>
                    
                 </div>

                 <div className='local_map'>

                 </div>

                 <div className='local_info'>

                 </div>
            </div>
            <Link to="/planner/lodging" className='next_link'><button className='next_btn'>다음</button></Link>
        </div>
        
    )
}
export default Location