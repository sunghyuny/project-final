import React from 'react'
import {Link} from 'react-router-dom'
import '../../Main.css';
import Navbar from '../../components/navbar';
import Footer from '../../components/footer';
import Review from '../../components/review'
import Recommend from '../../components/recommend'




function Home(){
    
    return(
        <main className='App'>
            <Navbar/>
            <div className='main_slide'>
                <img src='/image/다운로드 (1).jpeg' alt='슬라이드 이미지' className='slide_img'></img>
                <div className='main_text'>
                    <p className='main_title'>Travel Plan에서 자신만의 여행 일정을 작성해 보세요.</p>
                    <p className='sub_title'>일정을 만들고, 친구와 공유할 수 있습니다.</p>
                    <Link to='/planner/schedule' className='create_link'><button className='create_btn'>일정 작성하기</button></Link>
                </div>
            </div>
            <p className='content_title'>인기 여행지</p>
            <Recommend/>
            <hr></hr>
            
            <p className='content_title'>지금 가면 좋은 여행 장소</p>
            <Review imageUrl="/image/00501234_20171219.jpeg" locate="한라산 백록담" title="겨울 설경이 아름다운 곳" user="정보라님의 여행"/>
            <Review imageUrl="/image/266BE146585C7D782A.jpeg" locate="인제 자작나무 숲" title="모든게 하얗게 뒤덮힌 자작나무 숲" user="하인성님의 여행"/>
            <Review imageUrl="/image/11772BB7-D64A-4864-A05A-A93C060C3D6D.jpeg" locate="강릉 안반데기" title="밤하늘의 아름다운 은하수" user="안기준의 여행"/>
            <Review imageUrl="/image/ZkeHUfn8vIMkFLw3xvn9GvGV5tU4U5g0PxCvZzQ-eIaVhKA57AjIGEpwdYrbRSfh_pA9endPgdUeh3OLGGJzMw.webp" locate="청송 얼음골" title="멋진 겨울의 절경" user="홍장미님의 여행"/>

            <p className='content_title'>추천 여행</p>
            <Review imageUrl="/image/e4e76e16-ba3e-4ce6-8f97-d78d840bbc50.jpg" locate="여수" title="낭만적인 여수 밤바다" user="오연주님의 여행"/>
            <Review imageUrl="/image/20191229160530047_oen.jpeg" locate="광안리" title="광안리의 밤은 낮보다 아름답다" user="브라운님의 여행"/>
            <Review imageUrl="/image/e3c18663-14e2-49e3-b9f0-bd7a029a661f.jpg" locate="경주" title="1000년의 역사가 살아 숨쉬는 곳" user="남건님의 여행"/>
            <Review imageUrl="/image/84475_138812_3755.jpg" locate="남이섬" title="가을 단풍명소" user="이하연님의 여행"/> 

            <p className='content_title'>여행자 후기</p>
            <Review imageUrl="/image/2671612_image2_1.jpg" locate="오이도" title="아름다운 낙조를 볼 수 있는곳" user="유미란님의 여행" />
            <Review imageUrl="/image/hd6_394_i1.jpg" locate="수원화성" title="세계문화유산 화성" user="남도일님의 여행"/>
            <Review imageUrl="/image/7130-11.jpg" locate="덕수궁 돌담길" title="가을철 필수 방문지" user="고뭉치님의 여행"/>
            <Review imageUrl="/image/2022042716150600.jpg" locate="비둘기낭 폭포" title="겸손해야 보이는 아름다움" user="한아름님의 여행"/>

            <Footer/>
        </main>
    )
}
export default Home;