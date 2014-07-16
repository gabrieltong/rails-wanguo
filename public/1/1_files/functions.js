/*******************************************************************************
 *                                                                             *
 *   Copyright 2006-2008 The Learning Network, Inc.                            *
 *                                                                             *
 *   This file is part of Trellis.                                             *
 *                                                                             *
 *   Trellis is free software; you can redistribute it and/or modify           *
 *   it under the terms of the GNU General Public License as published by      *
 *   the Free Software Foundation; either version 3 of the License, or         *
 *   (at your option) any later version.                                       *
 *                                                                             *
 *   Trellis is distributed in the hope that it will be useful,                *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 *   GNU General Public License for more details.                              *
 *                                                                             *
 *   You should have received a copy of the GNU General Public License         *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.     *
 *                                                                             *
 ******************************************************************************/

function selectField(field)
{
    var f = field;
    f.focus();
    f.select();
}

function showStates(country_selector, state_field_prefix)
{
    var country = $('select#' + country_selector).val();
    $('#' + state_field_prefix + 'us').hide();
    $('#' + state_field_prefix + 'ca').hide();
    $('#' + state_field_prefix + 'intl').hide();
    if (country == 'US')
    {
        $('#' + state_field_prefix + 'us').show();
    }
    else if (country == 'CA')
    {
        $('#' + state_field_prefix + 'ca').show();
    }
    else
    {
        $('#' + state_field_prefix + 'intl').show();
    }
}
