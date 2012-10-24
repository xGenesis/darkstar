﻿/*
===========================================================================

  Copyright (c) 2010-2012 Darkstar Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

  This file is part of DarkStar-server source code.

===========================================================================
*/

#include "merit.h"

#include <string.h>

/************************************************************************
*                                                                       *
*  Две версии значений - до abyssea и после                             *
*                                                                       *
************************************************************************/

// массив больше на одно значение, заполняемое нулем

#if define ABYSSEA_EXPANSION
static uint8 upgrade[8][16] =
{
    {1,2,3,4,5,5,5,5,5,7,7,7,9,9,9},
    {3,6,9,9,9,12,12,12,12,15,15,15},
    {1,2,3,3,3,3,3,3},
    {1,2,3,3},
    {1,2,3,3,3,3,3,3},
    {1,2,3,4,5},
    {1,2,3,4,5},
    {3,4,5,5,5},
};
#else
static uint8 upgrade[8][9] =
{
    {1,2,3,4,5,5,5,5},
    {3,6,9,9,9},
    {1,2,3,3,3,3,3,3},
    {1,2,3,3},
    {1,2,3,3,3,3,3,3},
    {1,2,3,4},
    {1,2,3,4,5},
    {3,4,5,5,5},
};
#endif

/************************************************************************
*                                                                       *
*  Количество элементов в каждой из категорий                           *
*                                                                       *
************************************************************************/

static const uint8 count[] =
{
    2,  //MCATEGORY_HP_MP      
    7,  //MCATEGORY_ATTRIBUTES 
    19, //MCATEGORY_COMBAT 
    12, //MCATEGORY_MAGIC 
    5,  //MCATEGORY_OTHERS 
    5,  //MCATEGORY_WAR_1 
    5,  //MCATEGORY_MNK_1 
    5,  //MCATEGORY_WHM_1 
    7,  //MCATEGORY_BLM_1 
    7,  //MCATEGORY_RDM_1 
    5,  //MCATEGORY_THF_1 
    5,  //MCATEGORY_PLD_1 
    5,  //MCATEGORY_DRK_1 
    5,  //MCATEGORY_BST_1 
    5,  //MCATEGORY_BRD_1 
    5,  //MCATEGORY_RNG_1 
    5,  //MCATEGORY_SAM_1 
    7,  //MCATEGORY_NIN_1 
    4,  //MCATEGORY_DRG_1 
    5,  //MCATEGORY_SMN_1 
    5,  //MCATEGORY_BLU_1 
    5,  //MCATEGORY_COR_1 
    5,  //MCATEGORY_PUP_1 
    4,  //MCATEGORY_DNC_1 
    4,  //MCATEGORY_SCH_1 
    0,  //MCATEGORY_UNK_0 
    0,  //MCATEGORY_UNK_1 
    0,  //MCATEGORY_UNK_2 
    0,  //MCATEGORY_UNK_3 
    0,  //MCATEGORY_UNK_4 
    0,  //MCATEGORY_UNK_5 
    4,  //MCATEGORY_WAR_2 
    4,  //MCATEGORY_MNK_2 
    4,  //MCATEGORY_WHM_2 
    6,  //MCATEGORY_BLM_2 
    6,  //MCATEGORY_RDM_2 
    4,  //MCATEGORY_THF_2 
    4,  //MCATEGORY_PLD_2 
    4,  //MCATEGORY_DRK_2 
    4,  //MCATEGORY_BST_2 
    4,  //MCATEGORY_BRD_2 
    4,  //MCATEGORY_RNG_2 
    4,  //MCATEGORY_SAM_2 
    8,  //MCATEGORY_NIN_2 
    4,  //MCATEGORY_DRG_2 
    6,  //MCATEGORY_SMN_2 
    4,  //MCATEGORY_BLU_2 
    4,  //MCATEGORY_COR_2 
    4,  //MCATEGORY_PUP_2 
    4,  //MCATEGORY_DNC_2 
    6,  //MCATEGORY_SHC_2 
};

/************************************************************************
*                                                                       *
*                                                                       *
*                                                                       *
************************************************************************/

CMeritPoints::CMeritPoints()
{
    memset(merits, 0, sizeof(merits));

    for (uint8 m = 0, i = 0; i < sizeof(Categories)/sizeof(Merit_t*); ++i)
    {
        Categories[i] = &merits[m];

        for (uint8 t = 0; t < count[i]; ++t)
        {
            merits[m++].id = (i + 1) * 0x40 + t * 2;
        }
    }
    LoadingCharMerits();
}

/************************************************************************
*                                                                       *
*  Загружаем текущие merits персонажа                                   *
*                                                                       *
************************************************************************/

void CMeritPoints::LoadingCharMerits()
{
    return;
}

/************************************************************************
*                                                                       *
*  Получаем указатель на искомый merit                                  *
*                                                                       *
************************************************************************/

Merit_t* CMeritPoints::GetMerit(MERIT_TYPE merit)
{
    DSP_DEBUG_BREAK_IF(merit >= MCATEGORY_COUNT);
    DSP_DEBUG_BREAK_IF(((merit & 0x3F) >> 1) >= count[merit/0x40]);

    return &Categories[merit/0x40][(merit & 0x3F) >> 1];
}