import React, {useState} from 'react'
import { Link } from 'react-router-dom'
import Navbar from '../../components/navbar'
import Lodg from '../../components/lodg'


function Lodging (){
    const [dropdownVisibility, setDropdownVisibility] = useState(false);
    const [dropdownItems] = useState(["호텔", "모텔", "여관", "민박"]);

    const toggleDropdown = () => {
        setDropdownVisibility(!dropdownVisibility);
    };

    const handleItemClick = (item) => {
        console.log(`Selected: ${item}`);
        // 여기서 선택된 아이템에 따라 필요한 동작을 수행할 수 있습니다.
    };

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
                <div className='Circle'>
                    <p>활동</p>
                </div>
                <div className='Circle'>
                    <p>요약</p>
                </div>
            </div>
            <div className='Search_filter'>
                <div className='filter_title'>
                    <p>검색 필터</p>
                    <div className='dropdown_menu'>
                    <button onClick={toggleDropdown} className='drop_btn'>종류</button>
                        {dropdownVisibility && (
                            <div className="dropdown-content">
                                {dropdownItems.map((item, index) => (
                                    <div key={index} className="dropdown-item" onClick={() => handleItemClick(item)}>
                                        {item}
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                    <div className='scope_filter'>
                        ☆☆☆☆☆
                    </div>
                </div>
            </div>

            <div className='lodg_list'>
                <Lodg imageUrl="/image/family-twin-rom-with.jpg" title="부천대 호텔" locate="서귀포"  price="220,000원/1박" scope="★★★☆☆" review="후기 190개"/>
                <Lodg imageUrl="/image/family-twin-rom-with.jpg" title="부천대 호텔" locate="서귀포"  price="220,000원/1박" scope="★★★☆☆" review="후기 190개"/> 
            </div>
            <Link to="/planner/activity" className='next_link'><button className='next_btn'>다음</button></Link>
        </div>
    )
}
export default Lodging