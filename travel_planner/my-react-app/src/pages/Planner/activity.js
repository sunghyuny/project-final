import React from 'react'
import {Link} from 'react-router-dom'
import Navbar from '../../components/navbar'
import Active from '../../components/active'

function Activity(){
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
                <div className='Fill_Circle'>
                    <p>숙소</p>
                </div>
                <div className='Fill_Circle'>
                    <p>활동</p>
                </div>
                <div className='Circle'>
                    <p>요약</p>
                </div>
            </div>
            <p className='page_title'>활동 선택</p>
            <hr></hr>
            <input type="text" className="active_seach" placeholder='식당, 경관, 체험, 전시 등 가고 싶은 곳을 검색해보세요'></input>
            <div className='active_list'>
                <Active imageUrl="/image/다운로드 (4).jpeg" title="춘심이네 본점" add="제주 서귀포시 안덕면 창천중앙로 24번길 16"  time="운영시간 11:00 ~ 20:20" price="가격: 190,000원" ph="0507-1420-4018"/>
                
            </div>
            <Link to="/planner/summary" className='next_link'><button className='next_btn'>다음</button></Link>
        </div>
        
    )
}
export default Activity