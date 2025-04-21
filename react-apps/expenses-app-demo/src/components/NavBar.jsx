import { useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import MenuOptions from "./MenuOptions"
import Logo from './Logo'

const NavBar = () => {
    const [isMenuOpen, setIsMenuOpen] = useState(false)
    const location = useLocation()
    const isActive = (path) => location.pathname === path

    const toggleMenu  = () => {
        setIsMenuOpen((prev) => !prev) 
    }

    const closeMenu = () => {
        setIsMenuOpen(false)
    }

    return (
        <nav className='navbar d-flex'>
            <div className='navbar_menu d-flex'>
                <Logo />
                <Link className='navbar_menu_link' to='/detail/market' onClick={closeMenu}>
                    <div>Super</div>
                    <div className={isActive('/detail/market') ? 'underline' : ''}></div>
                </Link>
                <Link className='navbar_menu_link' to='/detail/fuel' onClick={closeMenu}>
                    <div>Combustible</div>
                    <div className={isActive('/detail/fuel') ? 'underline' : ''}></div>
                </Link>
                <Link className='navbar_menu_link' to='/detail/others' onClick={closeMenu}>
                    <div>Otros</div>
                    <div className={isActive('/detail/others') ? 'underline' : ''}></div>
                </Link>
            </div>
            <MenuOptions isOpen={isMenuOpen} toggleMenu={toggleMenu} />
        </nav>
    )
}

export default NavBar
