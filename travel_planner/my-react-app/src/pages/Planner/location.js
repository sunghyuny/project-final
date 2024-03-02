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
                    <p>제주시, 제주도</p>
                    <p>서귀포시, 제주도</p>
                 </div>

                 <div className='local_map'>
                    <img src='/image/스크린샷 2024-01-17 232154.png' alt='지도'></img>
                 </div>

                 <div className='local_info'>
                    <p>한국의 섬 중에서 가장 크고 인구가 많은 한라산체로 이루어진 섬이다. 화산에 의해 형성된 섬으로 해안선이 비교적으로 단순하고 화산 활동의 영향으로 일부 모래사장을 제외하면 모두 바위 해안으로 이루어져있다.</p>
                 </div>
            </div>
            <Link to="/planner/lodging" className='next_link'><button className='next_btn'>다음</button></Link>
        </div>
        
    )
}
export default Location