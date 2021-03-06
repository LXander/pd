// PD is a free, modular C++ library for biomolecular simulation with a 
// flexible and scriptable Python interface. 
// Copyright (C) 2003-2013 Mike Tyka and Jon Rea
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#ifndef __ROTLIBCONVERT_SHETTY_H
#define __ROTLIBCONVERT_SHETTY_H

#include "library/rotamerlib.h" // Base class

namespace Library
{
	class PD_API RotLibConvert_Shetty : public RotLibConvertBase
	{
		public: // Very limited publc interface - you can just make one...
			RotLibConvert_Shetty();
		protected:
			/// The core of this class is used to call addRotamer() on the library
			virtual void readLib( const std::string& _LibraryFileName, RotamerLibrary& _RotLib );
	};
}

#endif

