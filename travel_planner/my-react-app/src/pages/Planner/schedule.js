import React from "react";
import { Link } from "react-router-dom"
import Navbar from "../../components/navbar"



function Schedule(){
    return(
        <div>
            <Navbar/>
            <div className="progress">
                <div className='Fill_Circle'>
                    <p>기간/<br></br>인원</p>
                </div>
                <div className='Circle'>
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
            <div className="contents">
                <p className="page_title">기간/인원 선택</p>
                <div className="">
                    <div className="start_day">
                        <p>가는 날</p>
                        <p className="start_date"></p>
                    </div>

                    <div className="finish_day">
                        <p>오는날</p>
                        <p className="finish_date"></p>
                    </div>

                    <div className="personnel">

                    </div>
                    <Link to='/planner/location' className='next_link'><button className="next_btn">다음</button></Link>
                </div>
            </div>
        </div>
    )
}
export default Schedule