import React from "react";
import { useLocation } from "react-router-dom"; // useLocation을 import합니다.
import Navbar from "../../components/navbar";

function Search() {
  const location = useLocation(); // 현재 위치의 location 객체를 가져옵니다.

  // URLSearchParams API를 사용하여 쿼리 파라미터를 파싱합니다.
  const searchParams = new URLSearchParams(location.search);
  // 'query' 파라미터의 값을 가져옵니다. 없을 경우 기본값은 빈 문자열입니다.
  const query = searchParams.get('query') || '';

  return (
    <div className="search_page">
        <Navbar/>
        <div className="search_container">
            <p className="result_query">{query}</p>
            <p className="search_result">검색결과</p>
        </div>
        <div className="search_item">
            <input className="search_text" type="text" placeholder="검색어를 입력하세요"></input>
        </div>
        <div className="result_list">
            <div className="list_content">
                <img src="/image/96a5e9d7-4d49-4c4b-9bd8-87d66e18d205.jpg" alt="장소 이미지" className="place_img"></img>
                <div className="place_detail">
                    <p className="place_name">속초시립박물관</p>
                    <p className="place_tag">#강원도 #속초 #실내 #박물관</p>
                    <p className="place_info">속초 고유의 인문환경과 유명 관광지, 문화적 특징, 고장의 역사 등을 상설 전시해놓은 곳이다. 또한 전통문화를 체험할 수 있는 전시실을 통해 속초의 민속문화를 소개하고 경험의 기회를 제공하고 있다.</p>
                </div>
            </div>


            <div className="list_content">
                <img src="/image/설악산.jpg" alt="장소 이미지" className="place_img"></img>
                <div className="place_detail">
                    <p className="place_name">설악산</p>
                    <p className="place_tag">#강원도 #설악산 #인제 #고성 #울산바위</p>
                    <p className="place_info">설악산은 천연보호구역, 국립공원, 생물권보전지역으로 지정된 우리나라 식물자원의 보고이다. 낙엽활엽수와 상록침엽수의 혼효림으로 이루어져있고, 부분적으로는 단순림을 형성한 곳도 있다.</p>
                </div>
            </div>


            <div className="list_content">
                <img src="/image/32aca3fe-9499-4d7f-8df1-2b70c839c8c3.jpg" alt="장소 이미지" className="place_img"></img>
                <div className="place_detail">
                    <p className="place_name">미인폭포</p>
                    <p className="place_tag">#강원도 #삼척 #가족여행 #풍경 #자연</p>
                    <p className="place_info">한국에서 보기 드문 에메랄드빛 폭포로 유명하다. 태백시와 삼척시의 경계 지점에 자리한다. 오랜 세월 침식작용이 빚어낸 붉은 협곡과 신비한 빛을 자아내는 폭포가 어우러져 사시사철 많은 발길을 끌어들인다.</p>
                </div>
            </div>


            <div className="list_content">
                <img src="/image/20a11b2a-8e92-49fe-b353-6441d31246ef.jpg" alt="장소 이미지" className="place_img"></img>
                <div className="place_detail">
                    <p className="place_name">철원 한탄강 주상절리길</p>
                    <p className="place_tag">#강원도 #철원 #가족여행 #데이트 #산책</p>
                    <p className="place_info">한탄강 유네스코 세계지질공원에 위치한 철원한탄강 주상절리한탄강의 대표적인 주상절리 협곡과 다채로운 바위로 가득한 순담계곡에서 절벽을 따라, 절벽과 허공사이를 따라 걷는 잔도로 아찔한 스릴과 아름다운 풍경을 동시에 경험하는 곳이다.</p>
                </div>
            </div>
        </div>
    </div>



  );
}

export default Search;
