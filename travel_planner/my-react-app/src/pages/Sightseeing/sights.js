import React, { useState } from "react";
import Navbar from "../../components/navbar";
import { useNavigate } from 'react-router-dom';

function Sights() {
  // content 상태를 관리하여 'island'와 'inland' 사이를 전환
  const [content, setContent] = useState("island");

  const [searchQuery, setSearchQuery] = useState(""); // 검색 쿼리를 위한 상태
  const navigate = useNavigate(); // useNavigate 훅을 사용합니다.

  // 검색 입력 값이 변경될 때마다 호출되는 함수
  const handleSearchChange = (e) => {
    setSearchQuery(e.target.value);
  };


  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
        navigate(`/sightseeing/Sights/search?query=${searchQuery}`);
    }
  };

  // 검색 버튼이 클릭되었을 때 호출되는 함수
  const handleSearchClick = () => {
    // navigate 함수를 사용하여 검색 페이지로 이동하고, 검색 쿼리를 URL 파라미터로 전달합니다.
    navigate(`/sightseeing/Sights/search?query=${searchQuery}`);
  };

  return (
    <div className="sights_page">
      <Navbar />
      <div className="sights_content">

        <div className="top_img">
        <img src="/image/p_main_13706 (1).jpg" alt="" className="top_image"></img>
            <div className="search_container">
                <input className="searchtext" type="text" placeholder="검색할 내용을 입력하세요" value={searchQuery}
              onChange={handleSearchChange} onKeyPress={handleKeyPress}/>
                <button className="search_btn" onClick={handleSearchClick}>검색</button>
            </div>
        </div>

        <div className="content_selection">
            <p onClick={() => setContent("island")} className={`show_island ${content === 'island' ? 'island_selected' : ''}`}>제주/섬 여행</p>
            <p onClick={() => setContent("inland")} className={`show_inland ${content === 'inland' ? 'inland_selected' : ''}`}>내륙여행</p>
        </div>

        {content === "island" ? (
            <div className="island_content">
                <div className="hot_sights">
                    <p className="list_title">많이 찾는 관광지</p>
                    <ul className="destination_list">
                        <li>제주도</li>
                        <li>흑산도</li>
                        <li>울릉도</li>
                        <li>백령도</li>
                        <li>마라도</li>
                    </ul>
                </div>

                <div className="popular_sights">
                    <p className="list_title">인기 추천</p>
                    <div className="recommend_place">
                        <img src="/image/1600843915748.jpg" alt="관광지 이미지" className="recommend_picture"></img>
                        <p className="recommend_name">제주 대포해안 주상절리</p>
                    </div>
                </div>

                <div className="visit_sights">
                    <p className="list_title">가볼만한 곳</p>
                    <div className="recommend_place">
                        <img src="/image/다운로드 (16).jpeg" alt="관광지 이미지" className="recommend_picture"></img>
                        <p className="recommend_name">제주 감귤체험</p>
                    </div>
                </div>

                <div className="sights_list">
                    <p className="list_title">관광지</p>
                    <div className="sights_island">
                        <img src="/image/마라도7_대한민국_최남단_마라도DJI_0045.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">마라도</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/74225b48-2e5e-478c-9f3f-57b5d4dffb61.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">백령도</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/110.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">홍도</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/22417_82284_3619.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">흑산도</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/visual03.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">울릉도</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/6500_22519_2612.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">제주도</p>
                    </div>
                </div>
            </div>
            ) : (
            <div className="inland_content">
                <div className="hot_sights">
                    <p className="list_title">많이 찾는 관광지</p>
                    <ul className="destination_list">
                    <li>전주</li>
                    <li>강릉</li>
                    <li>울산</li>
                    <li>강화도</li>
                    <li>경주</li>
                    </ul>
                </div>

                <div className="popular_sights">
                    <p className="list_title">인기 추천</p>
                    <div className="recommend_place">
                        <img src="/image/GFXA4415-1.jpg" alt="관광지 이미지" className="recommend_picture"></img>
                        <p className="recommend_name">도깨비 촬영지 주문진</p>
                    </div>
                </div>

                <div className="visit_sights">
                    <p className="list_title">가볼만한 곳</p>
                    <div className="recommend_place">
                        <img src="/image/88dec60e-8cd1-42cc-b7d8-34b67f7d923c.jpg" alt="관광지 이미지" className="recommend_picture"></img>
                        <p className="recommend_name">해돋이 명소 호지곶</p>
                    </div>
                </div>

                <div className="sights_list">
                    <p className="list_title">관광지</p>

                    <div className="sights_island">
                        <img src="/image/설악산.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">설악산 국립공원</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/29O6N859LQ_1.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">행주산성</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/shutterstock_692827960_12008800-1024x683.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">경복궁</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/자수정동굴.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">울산 자수정동굴</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/20221227091306_ilcqltrt.jpg" alt="관광지 이미지" className="place_picture"></img>
                        <p className="sights_name">태백 상장동 벽화마을</p>
                    </div>

                    <div className="sights_island">
                        <img src="/image/061A4221.jpg" alt="관광지 이미지" className="place_picture"></img>
                         <p className="sights_name">용인 한국민속촌</p>
                    </div>
                </div>
            </div>
            )
        }
        </div>
    </div>
  );
}

export default Sights;
